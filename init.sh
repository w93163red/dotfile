#!/bin/zsh

# cp .zshrc ~/
#cp .tmux.conf .tmux.conf.local ~/
#mkdir -p ~/.config/nvim
#cp init.vim ~/.config/nvim
#cp .ideavimrc ~/
#cp .vimrc ~/

cd ~
#git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

#git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

sudo wget https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage -P /usr/local/bin
sudo mv /usr/local/bin/nvim.appimage /usr/local/bin/nvim
sudo chmod +x /usr/local/bin/nvim
#sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
#       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

#source ~/.zshrc
#cargo install exa bat
nvm install --lts

