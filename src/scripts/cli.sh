#!/bin/bash

# TODO: Install dependencies for neovim for apt and dnf
# https://github.com/neovim/neovim/wiki/Installing-Neovim/e24ab440745f569ed931c6a7a2b2b714b01c7ddf

cliTools=("alacritty" "bat" "curl" "exa" "eza" "fd" "htop" "jq" "neovim" "openvpn" "ripgrep" "terminator" "tmux" "vim" "wget" "zsh")
for cliTool in "${cliTools[@]}"; do
    if [[ ! -f "/usr/bin/$cliTool" && ! -f "/usr/sbin/$cliTool" ]]; then
        sudo apt install "$cliTool" -y
    fi
done

# fastfetch
sudo add-apt-repository ppa:zhangsongcui3371/fastfetch
sudo apt update 
sudo apt install fastfetch -y

### Package managers ###

# Flatpak
if [[ ! -f "/usr/bin/flatpak" ]]; then
    sudo apt install flatpak -y
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi
