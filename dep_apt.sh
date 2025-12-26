#!/bin/bash
# dependencies
sudo apt install -y git curl wget tmux universal-ctags zsh autojump build-essential libssl-dev fzf nodejs eza bat fuse libfuse2t64 ripgrep fd-find
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash
