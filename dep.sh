#!/bin/bash
# dependencies
sudo apt install -y git curl wget tmux python2 universal-ctags zsh autojump build-essential libssl-dev fzf

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"


