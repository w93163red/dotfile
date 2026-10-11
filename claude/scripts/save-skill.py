#!/usr/bin/env python3
"""Save a reusable skill under ~/.claude/skills/<name>/SKILL.md.

Reads the SKILL.md body (markdown, no frontmatter) from stdin. Validates the
name (kebab-case, <=64 chars) and description (single line, <=1024 chars).
On success, invokes the existing PostToolUse backyards-sync hook with a
synthetic payload so mirroring stays consistent.

Usage:
    save-skill.py --name <kebab-name> --description "<one-line>" \
        [--force] [--dry-run] < body.md
"""
import argparse
import json
import os
import re
import subprocess
import sys
from pathlib import Path

NAME_RE = re.compile(r"^[a-z][a-z0-9-]{0,63}$")
MAX_DESCRIPTION = 1024
MAX_BODY = 100_000

SKILLS_ROOT = Path.home() / ".claude" / "skills"
SYNC_HOOK = Path.home() / ".claude" / "hooks" / "sync-skills-to-backyards.sh"
PROVENANCE = Path.home() / ".claude" / "state" / "skill-provenance.json"


def record_provenance(name: str, owner: str) -> None:
    """Register a newly created skill's owner.

    Existing entries are never rewritten: a --force overwrite of a user-owned
    skill must not silently reclassify it as agent-owned and thus freely
    editable by the autonomous review pass.
    """
    try:
        reg = json.loads(PROVENANCE.read_text(encoding="utf-8"))
        if not isinstance(reg, dict):
            reg = {}
    except (OSError, ValueError):
        reg = {}
    if name in reg:
        return
    reg[name] = {"created_by": owner, "auto_update": owner == "agent"}
    try:
        PROVENANCE.parent.mkdir(parents=True, exist_ok=True)
        PROVENANCE.write_text(
            json.dumps(dict(sorted(reg.items())), indent=2, ensure_ascii=False) + "\n",
            encoding="utf-8",
        )
    except OSError as e:
        print(f"warning: could not record provenance for {name}: {e}", file=sys.stderr)


def main() -> int:
    p = argparse.ArgumentParser(
        description="Save a reusable skill under ~/.claude/skills/<name>/SKILL.md."
    )
    p.add_argument("--name", required=True,
                   help="kebab-case skill name, e.g. debug-spark-oom")
    p.add_argument("--description", required=True,
                   help="single-line when-to-use description (<=1024 chars)")
    p.add_argument("--force", action="store_true",
                   help="overwrite an existing SKILL.md")
    p.add_argument("--dry-run", action="store_true",
                   help="validate inputs and print would-be content; do not write")
    p.add_argument("--owner", choices=("agent", "user"), default="agent",
                   help="who owns this skill; agent-owned skills may be patched "
                        "autonomously by the skill-review pass (default: agent)")
    args = p.parse_args()

    if not NAME_RE.match(args.name):
        sys.exit(f"error: --name must match {NAME_RE.pattern} (kebab-case, <=64 chars)")
    if "\n" in args.description or "\r" in args.description:
        sys.exit("error: --description must be a single line (no newlines)")
    if len(args.description) > MAX_DESCRIPTION:
        sys.exit(f"error: --description exceeds {MAX_DESCRIPTION} chars (got {len(args.description)})")

    if sys.stdin.isatty():
        sys.exit("error: SKILL.md body must be piped via stdin")
    body = sys.stdin.read().strip()
    if not body:
        sys.exit("error: empty body -- pipe SKILL.md markdown via stdin")
    if len(body) > MAX_BODY:
        sys.exit(f"error: body exceeds {MAX_BODY} chars (got {len(body)})")
    if body.lstrip().startswith("---"):
        sys.exit("error: body must NOT include frontmatter; pass --name/--description as flags")

    desc_yaml = args.description.replace("\\", "\\\\").replace('"', '\\"')
    skill_md_content = (
        "---\n"
        f"name: {args.name}\n"
        f'description: "{desc_yaml}"\n'
        "---\n\n"
        f"{body}\n"
    )

    skill_dir = SKILLS_ROOT / args.name
    skill_md = skill_dir / "SKILL.md"

    if args.dry_run:
        print(f"# would write {skill_md} ({len(skill_md_content)} chars)")
        print("---8<---")
        print(skill_md_content, end="")
        print("---8<---")
        return 0

    if skill_md.exists() and not args.force:
        sys.exit(f"error: {skill_md} already exists; pass --force to overwrite")

    skill_dir.mkdir(parents=True, exist_ok=True)
    skill_md.write_text(skill_md_content, encoding="utf-8")
    record_provenance(args.name, args.owner)

    if SYNC_HOOK.is_file() and os.access(SYNC_HOOK, os.X_OK):
        payload = json.dumps({
            "tool_name": "save-skill.py",
            "tool_input": {"file_path": str(skill_md)},
        })
        try:
            subprocess.run(
                [str(SYNC_HOOK)],
                input=payload,
                text=True,
                check=False,
                timeout=30,
            )
        except (subprocess.SubprocessError, OSError) as e:
            print(f"warning: backyards sync hook failed: {e}", file=sys.stderr)

    print(f"saved skill: {skill_md}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
