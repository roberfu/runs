#!/bin/bash

sudo apt update
sudo apt upgrade -y
sudo apt install -y git python3-full stow tree maven fzf ripgrep openjdk-21-jdk \
golang-go rustup

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

nvm install node --lts
source ~/.bashrc

git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git $HOME/vendors/nerd-fonts
cd $HOME/vendors/nerd-fonts
./install.sh JetBrainsMono
