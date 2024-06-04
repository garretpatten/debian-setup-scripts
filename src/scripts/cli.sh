#!/bin/bash

errorMessage=$1
packageManager=$2

# TODO: Install dependencies for neovim for apt and dnf
# https://github.com/neovim/neovim/wiki/Installing-Neovim/e24ab440745f569ed931c6a7a2b2b714b01c7ddf

cliTools=("bat" "curl" "exa" "git" "htop" "neovim" "openvpn" "vim" "wget" "zsh")
for cliTool in "${cliTools[@]}"; do
    if [[ -d "/usr/bin/$cliTool" ]]; then
        echo "$cliTool is already installed."
    elif [[ -f "/usr/sbin/$cliTool" ]]; then
        echo "$cliTool is already installed."
    else
        if [[ "$packageManager" = "apt-get" || "$packageManager" = "dnf" ]]; then
            sudo "$packageManager" install "$cliTool" -y
        elif [[ "$packageManager" = "pacman" ]]; then
            sudo pacman -S "$cliTool" --noconfirm
        else
            echo "$cliTool $errorMessage"
        fi
    fi
done

# fastfetch
if [[ "$packageManager" = "apt" ]]; then
    sudo add-apt-repository ppa:zhangsongcui3371/fastfetch
    sudo apt update 
    sudo apt install fastfetch -y
elif [[ "$packageManager" = "dnf" ]]; then
    sudo dnf install fastfetch -y
elif [[ "$packageManager" = "pacman" ]]; then
    sudo pacman -S fastfetch -y
fi

### Package managers ###

# Flatpak
if [[ -f "/usr/bin/flatpak" ]]; then
	echo "flatpak is already installed."
else
	sudo "$packageManager" install flatpak -y
fi

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
