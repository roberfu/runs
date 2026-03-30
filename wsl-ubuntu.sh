#!/bin/bash

set -e

sudo apt update
sudo apt upgrade -y
sudo apt install -y git python3-full stow tree maven fzf ripgrep openjdk-21-jdk \
    golang-go rustup

if [ ! -d "$HOME/.nvm" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
fi
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

if ! command -v nvm &> /dev/null; then
    nvm install node --lts
fi
source $HOME/.bashrc

sudo apt-get install ninja-build gettext cmake curl build-essential git

if ! command -v nvim &> /dev/null; then
    if [ ! -d "$HOME/vendors/neovim" ]; then
        git clone https://github.com/neovim/neovim $HOME/vendors/neovim
    fi
    cd $HOME/vendors/neovim
    git checkout stable
    make CMAKE_BUILD_TYPE=RelWithDebInfo
    sudo make install
fi
source $HOME/.bashrc
