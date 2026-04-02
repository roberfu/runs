#!/bin/bash
set -e
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm --needed \
    mpv alacritty qbittorrent git python stow tree maven \
    fzf ripgrep jdk-openjdk go rustup podman unzip \
    ninja cmake curl base-devel

if ! command -v yay &> /dev/null; then
    if [ ! -d "$HOME/vendors/yay" ]; then
        git clone https://aur.archlinux.org/yay.git $HOME/vendors/yay
    fi
    pushd $HOME/vendors/yay
    makepkg -si --noconfirm
    popd
fi

if ! nvim --version &> /dev/null || [[ $(nvim --version 2>/dev/null | head -1 | cut -d' ' -f2) < "v0.9" ]]; then
    yay -S --noconfirm neovim-stable-bin
fi

if [ ! -d "$HOME/.nvm" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
fi
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

source ~/.bashrc
nvm install --lts

npm install -g tree-sitter-cli
npm i -g opencode-ai

yay -S --noconfirm ttf-hack-nerd

if ! command -v codium &> /dev/null; then
    yay -S --noconfirm vscodium-bin
fi

if ! command -v zed &> /dev/null; then
    curl -f https://zed.dev/install.sh | sh
fi
