#!/bin/bash

packageManager=$1

# Burp Suite
if [[ -f "/usr/bin/TODO" ]]; then
	echo "Burp Suite is already installed."
else
	if [[ "$packageManager" = "pacman" ]]; then
        currentPath=$(pwd)
        cd ~/Downloads

        git clone https://aur.archlinux.org/burpsuite.git
        cd burpsuite
        makepkg -sri --noconfirm

        cd "$currentPath"
	else
		sudo $packageManager install ufw -y
	fi
fi

# Black Arch tools
if [[ "$packageManager" = "pacman" ]]; then
    curl -O https://blackarch.org/strap.sh
    chmod +x strap.sh
    sudo ./strap.sh
else
    echo "Black Arch tools are not supported for this package manager."
fi

# Network Mapper
if [[ -f "/usr/bin/nmap" ]]; then
	echo "Network Mapper is already installed."
else
	if [[ "$packageManager" = "pacman" ]]; then
		echo y | sudo pacman -S nmap
	else
		sudo $packageManager install "$cliTool" -y
	fi
fi
