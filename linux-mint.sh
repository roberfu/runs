#!/bin/bash
set -e
sudo apt update
sudo apt upgrade -y
sudo apt install -y mpv alacritty qbittorrent git python3-full stow tree maven \
    fzf ripgrep openjdk-25-jdk golang-go rustup podman unzip

if [ ! -d "$HOME/.nvm" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
fi
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

source $HOME/.bashrc
nvm install --lts

sudo apt-get install -y ninja-build gettext cmake curl build-essential git

if ! nvim --version &> /dev/null || [[ $(nvim --version 2>/dev/null | head -1 | cut -d' ' -f2) < "v0.9" ]]; then
    if [ ! -d "$HOME/vendors/neovim" ]; then
        git clone https://github.com/neovim/neovim $HOME/vendors/neovim
    fi
    pushd $HOME/vendors/neovim
    git checkout stable
    make CMAKE_BUILD_TYPE=RelWithDebInfo
    sudo make install
    popd
fi

source $HOME/.bashrc

npm install -g tree-sitter-cli
npm i -g opencode-ai

if [ ! -d "$HOME/vendors/nerd-fonts" ]; then
    git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git $HOME/vendors/nerd-fonts
fi
pushd $HOME/vendors/nerd-fonts
./install.sh Hack
popd

if ! command -v codium &> /dev/null; then
    wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
        | gpg --dearmor \
        | sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg
    echo -e 'Types: deb\nURIs: https://download.vscodium.com/debs\nSuites: vscodium\nComponents: main\nArchitectures: amd64 arm64\nSigned-by: /usr/share/keyrings/vscodium-archive-keyring.gpg' \
    | sudo tee /etc/apt/sources.list.d/vscodium.sources
    sudo apt update && sudo apt install codium
fi

if ! command -v zed &> /dev/null; then
    curl -f https://zed.dev/install.sh | sh
fi
