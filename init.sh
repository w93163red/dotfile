#!/bin/sh

# dependencies
apt install git curl wget tmux python ctags

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

cp .zshrc ~/
cp .tmux.conf .tmux.conf.local ~/
mkdir -p ~/.config/nvim
cp init.vim ~/.config/nvim
cp .ideavimrc ~/


cd ~
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

git clone git://github.com/wting/autojump.git ~/autojump
~/autojump/install.py

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
echo "source ${(q-)PWD}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc

wget https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage -P /usr/local/bin
mv /usr/local/bin/nvim.appimage /usr/local/bin/nvim
chmod +x /usr/local/bin/nvim

source ~/.zshrc
cargo install exa bw3at
nvm install lts
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
