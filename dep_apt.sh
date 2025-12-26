#!/bin/bash
# dependencies
sudo apt install -y git curl wget tmux universal-ctags zsh autojump build-essential libssl-dev fzf nodejs eza bat fuse libfuse2t64 ripgrep fd-find
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
wget https://github.com/sxyazi/yazi/releases/download/nightly/yazi-x86_64-unknown-linux-gnu.deb
sudo apt install -y yazi-x86_64-unknown-linux-gnu.deb
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash
