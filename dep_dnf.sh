#!/bin/bash

# dependencies
sudo dnf install -y git curl wget tmux python2 ctags zsh autojump openssl-devel fzf nodejs exa bat npm fuse golang java-1.8.0-openjdk.x86_64 @development-tools
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"


