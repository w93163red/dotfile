#!/bin/zsh

cp .zshrc ~/
cp .tmux.conf .tmux.conf.local ~/
mkdir -p ~/.config/nvim
cp coc-settings.json init.vim ~/.config/nvim
cp .ideavimrc ~/
cp .vimrc ~/
mkdir -p ~/.config/herdr/
cp herdr_config.toml ~/.config/herdr/config.toml
mkdir -p ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/warp-edit
cp warp-edit/warp-edit.plugin.zsh ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/warp-edit/

mkdir -p ~/.claude/hooks ~/.claude/scripts
cp claude/hooks/skill-review.py ~/.claude/hooks/
cp claude/scripts/save-skill.py ~/.claude/scripts/
chmod +x ~/.claude/hooks/skill-review.py ~/.claude/scripts/save-skill.py
python3 - claude/settings.json <<'PY'
import json, sys
from pathlib import Path

dst = Path.home() / ".claude" / "settings.json"
src = json.loads(Path(sys.argv[1]).read_text())
cur = json.loads(dst.read_text()) if dst.exists() else {}
cur.setdefault("hooks", {}).update(src.pop("hooks", {}))
cur.update(src)
dst.write_text(json.dumps(cur, indent=2, ensure_ascii=False) + "\n")
PY
command -v claude >/dev/null || curl -fsSL https://claude.ai/install.sh | bash

cd ~
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab

if [[ "$(uname)" == Linux ]]; then
  sudo wget https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.appimage -P /usr/local/bin
  sudo mv /usr/local/bin/nvim-linux-x86_64.appimage /usr/local/bin/nvim
  sudo chmod +x /usr/local/bin/nvim
fi
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

source ~/.zshrc



