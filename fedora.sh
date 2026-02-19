#!/bin/bash

sudo dnf update -y
sudo dnf install -y neovim python3-neovim mpv alacritty qbittorrent \
git stow python3 tree maven fzf ripgrep java-21-openjdk golang-go \
rustup

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
sudo dnf install -y codium

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

nvm install node --lts
source ~/.bashrc

git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git $HOME/vendors/nerd-fonts
cd $HOME/vendors/nerd-fonts
./install.sh JetBrainsMono
