#!/bin/bash

set -e

sudo dnf update -y
sudo dnf install -y neovim python3-neovim mpv alacritty qbittorrent \
git stow python3 tree maven fzf ripgrep java-21-openjdk golang-go \
rustup

if [ ! -f /etc/yum.repos.d/vscodium.repo ]; then
    sudo tee -a /etc/yum.repos.d/vscodium.repo << 'EOF'
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

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

nvm install node --lts
source ~/.bashrc

if [ ! -d "$HOME/vendors/nerd-fonts" ]; then
    git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git $HOME/vendors/nerd-fonts
fi
cd $HOME/vendors/nerd-fonts
./install.sh JetBrainsMono
