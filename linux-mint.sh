#!/bin/bash

sudo apt update
sudo apt upgrade -y
sudo apt install -y mpv alacritty qbittorrent git python3-full stow tree maven \
fzf ripgrep openjdk-21-jdk golang-go rustup

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

nvm install node --lts
source $HOME/.bashrc

sudo apt-get install ninja-build gettext cmake curl build-essential git
git clone https://github.com/neovim/neovim $HOME/vendors/neovim
cd $HOME/vendors/neovim
git checkout stable
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
source $HOME/.bashrc

git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git $HOME/vendors/nerd-fonts
cd $HOME/vendors/nerd-fonts
./install.sh Hack
