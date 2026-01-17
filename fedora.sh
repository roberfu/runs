#!/bin/bash

sudo dnf update -y
sudo dnf install -y neovim python3-neovim mpv alacritty qbittorrent \
git stow python3 tree maven fzf ripgrep java-25-openjdk golang-go \
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
