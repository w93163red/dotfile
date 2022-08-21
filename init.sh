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

sudo wget https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage -P /usr/local/bin
sudo mv /usr/local/bin/nvim.appimage /usr/local/bin/nvim
sudo chmod +x /usr/local/bin/nvim
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
curl -fLo "Ubuntu Nerd Font Complete.ttf" \
   https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Ubuntu/Regular/complete/Ubuntu%20Nerd%20Font%20Complete.ttf
curl -fLo "MesloFont.ttf" \
   https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/Meslo/S/Regular/complete/Meslo%20LG%20S%20Regular%20Nerd%20Font%20Complete.ttf
source ~/.zshrc



