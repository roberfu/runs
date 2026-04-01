#!/bin/bash
set -e
sudo dnf update -y
sudo dnf install -y mpv alacritty qbittorrent git python3-full stow tree maven \
    fzf ripgrep java-latest-openjdk golang rustup podman unzip \
    ninja-build gettext cmake curl gcc gcc-c++ make

if [ ! -d "$HOME/.nvm" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
fi
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

source ~/.bashrc
nvm install --lts

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

source ~/.bashrc

npm install -g tree-sitter-cli
npm i -g opencode-ai

if [ ! -d "$HOME/vendors/nerd-fonts" ]; then
    git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git $HOME/vendors/nerd-fonts
fi
pushd $HOME/vendors/nerd-fonts
./install.sh Hack
popd

if [ ! -f /etc/yum.repos.d/vscodium.repo ]; then
    sudo tee /etc/yum.repos.d/vscodium.repo << 'EOF'
[gitlab.com_paulcarroty_vscodium_repo]
name=gitlab.com_paulcarroty_vscodium_repo
baseurl=https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/rpms/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg
metadata_expire=1h
EOF
fi
sudo dnf install -y codium

if ! command -v zed &> /dev/null; then
    curl -f https://zed.dev/install.sh | sh
fi
