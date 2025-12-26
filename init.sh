#!/bin/zsh

cp .zshrc ~/
cp .tmux.conf .tmux.conf.local ~/
mkdir -p ~/.config/nvim
cp coc-settings.json init.vim ~/.config/nvim
cp .ideavimrc ~/
cp .vimrc ~/

cd ~
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab

sudo wget https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.appimage -P /usr/local/bin
sudo mv /usr/local/bin/nvim-linux-x86_64.appimage /usr/local/bin/nvim
sudo chmod +x /usr/local/bin/nvim
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

source ~/.zshrc



