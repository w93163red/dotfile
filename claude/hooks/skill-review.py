#!/usr/bin/env python3
"""Stop hook: periodically force a skill-library review.

Port of hermes-agent's background-review trigger (agent/turn_finalizer.py).
Hermes counts tool-calling iterations since the last skill write and, past a
threshold, forks an agent whose only job is to update the skill library. Claude
Code has no fork primitive, so instead we block the Stop event and hand the
review instructions back to the model, which does the pass inline before
finishing. The block is emitted as JSON on stdout rather than exit 2 + stderr,
so the instructions reach the model without the prompt text landing in the
user's terminal.

Counting mirrors Hermes: the baseline resets both when a skill is actually
written and when a review fires, so a session that just reviewed does not
re-review on the next turn.

Disable with CLAUDE_SKILL_REVIEW=0. Force on (e.g. headless) with =1.
Tune the threshold with CLAUDE_SKILL_REVIEW_INTERVAL (default 15).
"""
import json
import os
import sys
import time
from pathlib import Path

STATE_DIR = Path.home() / ".claude" / "state" / "skill-review"
SKILLS_ROOT = str(Path.home() / ".claude" / "skills")
DEFAULT_INTERVAL = 15

REVIEW_PROMPT = """\
[skill-review] You have run {n} tool calls without touching the skill library. \
Before you finish this turn, review the conversation above and update \
~/.claude/skills/ — then give the user your normal answer, with one short line \
saying what you saved or that you saved nothing.

Be active. Most substantial sessions produce at least one update. A pass that \
does nothing is a missed learning opportunity, not a neutral result. But an \
update nobody needs is worse than none — see the exclusions below.

Any one of these warrants action:
- The user corrected your approach, workflow, or the order you did things in. \
Encode the correction as an explicit step or a pitfall in the skill that governs \
that class of task.
- The user corrected your style, format, verbosity, or language. That belongs in \
the skill body, not only in memory: memory is who the user is, a skill is how \
this kind of task should be done for them.
- A non-trivial technique, fix, workaround, or debugging path emerged that a \
future session would have to rediscover.
- A skill you loaded this session turned out to be wrong, incomplete, or stale. \
Patch it now.

Take the earliest option that fits:
1. Patch a skill already in play this session.
2. Patch the existing skill that owns this class of task.
3. Add references/<topic>.md under an existing skill, plus a one-line pointer \
from its SKILL.md.
4. Create a new skill only if no existing one covers the class. Name it at the \
class level — never after a ticket key, an error string, or today's task.

Do NOT record:
- Environment breakage (missing binary, unset credential, uninstalled package, \
stale path). Record the fix under a setup skill; never the failure as a rule.
- Negative claims about tools ("X doesn't work"). These harden into refusals you \
cite against yourself long after the problem is fixed.
- Transient errors that resolved. If a retry worked, the retry is the lesson.
- One-off task narratives.
- Unresolved attempts. If nothing actually worked, do not write the attempts up \
as a procedure. Record nothing, or only an alternative you are genuinely \
confident in — never the dead ends dressed as guidance.

Ownership (~/.claude/state/skill-provenance.json): patch agent-owned skills \
freely; user-owned ones are read-only — propose the change in your reply instead, \
unless the entry is flagged auto_update. A skill missing from the registry is \
user-owned.

Write with ~/.claude/scripts/save-skill.py (or edit the SKILL.md directly when \
patching). If nothing here clears the bar, say so in one line and finish — that \
is a valid outcome, just not the default one."""


def interactive_session() -> bool:
    """Skip cron/headless runs, which would burn tokens per tick.

    Claude Code sets CLAUDE_CODE_SESSION_ATTENDED=1 for the terminal TUI and for
    desktop/IDE/remote frontends, and 0 for `claude -p` and background sessions.
    Older versions don't set it, so fall back to sniffing the terminal.
    """
    attended = os.environ.get("CLAUDE_CODE_SESSION_ATTENDED")
    if attended is not None:
        return attended == "1"
    return bool(os.environ.get("TERM_PROGRAM") or os.environ.get("ITERM_SESSION_ID"))


def is_skill_write(entry: dict) -> bool:
    """True if this assistant tool_use wrote to the skill library."""
    name = entry.get("name") or ""
    inp = entry.get("input") or {}
    if not isinstance(inp, dict):
        return False
    if name in ("Write", "Edit", "NotebookEdit"):
        return str(inp.get("file_path", "")).startswith(SKILLS_ROOT)
    if name == "Bash":
        return "save-skill.py" in str(inp.get("command", ""))
    return False


def scan(transcript: Path):
    """Return (total tool calls, index of the last skill write)."""
    total = 0
    last_write = 0
    try:
        with transcript.open(encoding="utf-8", errors="replace") as fh:
            for line in fh:
                line = line.strip()
                if not line:
                    continue
                try:
                    rec = json.loads(line)
                except ValueError:
                    continue
                msg = rec.get("message") or {}
                if msg.get("role") != "assistant":
                    continue
                content = msg.get("content")
                if not isinstance(content, list):
                    continue
                for block in content:
                    if isinstance(block, dict) and block.get("type") == "tool_use":
                        total += 1
                        if is_skill_write(block):
                            last_write = total
    except OSError:
        return 0, 0
    return total, last_write


def prune_state(keep_days: int = 7) -> None:
    """Drop state for sessions that ended long ago; one file is written per session."""
    try:
        cutoff = time.time() - keep_days * 86400
        for f in STATE_DIR.glob("*.json"):
            try:
                if f.stat().st_mtime < cutoff:
                    f.unlink()
            except OSError:
                pass
    except OSError:
        pass


def main() -> int:
    if os.environ.get("CLAUDE_SKILL_REVIEW") == "0":
        return 0

    try:
        payload = json.load(sys.stdin)
    except (ValueError, OSError):
        return 0

    # Already blocked once this turn — never loop.
    if payload.get("stop_hook_active"):
        return 0

    if os.environ.get("CLAUDE_SKILL_REVIEW") != "1" and not interactive_session():
        return 0

    transcript = payload.get("transcript_path")
    session_id = payload.get("session_id")
    if not transcript or not session_id:
        return 0

    try:
        interval = int(os.environ.get("CLAUDE_SKILL_REVIEW_INTERVAL", DEFAULT_INTERVAL))
    except ValueError:
        interval = DEFAULT_INTERVAL
    if interval <= 0:
        return 0

    total, last_write = scan(Path(transcript))
    if total == 0:
        return 0

    state_file = STATE_DIR / f"{session_id}.json"
    last_fired = 0
    try:
        last_fired = int(json.loads(state_file.read_text(encoding="utf-8")).get("fired_at", 0))
    except (OSError, ValueError, AttributeError):
        pass

    baseline = max(last_fired, last_write)
    since = total - baseline
    if since < interval:
        return 0

    try:
        STATE_DIR.mkdir(parents=True, exist_ok=True)
        state_file.write_text(
            json.dumps({"fired_at": total, "session_id": session_id}),
            encoding="utf-8",
        )
    except OSError:
        # If state can't be persisted, firing anyway would repeat every turn.
        return 0

    prune_state()
    # JSON block instead of exit 2: `reason` goes to the model, suppressOutput
    # keeps the prompt out of the transcript the user sees.
    print(json.dumps({
        "decision": "block",
        "reason": REVIEW_PROMPT.format(n=since),
        "suppressOutput": True,
    }))
    return 0


if __name__ == "__main__":
    sys.exit(main())
