#!/bin/bash

packageManager=$1

# Burp Suite
if [[ -f "/usr/bin/burpsuite" ]]; then
	echo "Burp Suite is already installed."
else
	if [[ "$packageManager" = "pacman" ]]; then
        currentPath=$(pwd)
        cd ~/Downloads

        git clone https://aur.archlinux.org/burpsuite.git
        cd burpsuite
        makepkg -sri --noconfirm

        cd "$currentPath"\
    # TODO: Add support for apt and dnf
	else
		echo "Burp Suite is not supported for this package manager."
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
		sudo pacman -S --noconfirm nmap
	else
		sudo $packageManager install "$cliTool" -y
	fi
fi
