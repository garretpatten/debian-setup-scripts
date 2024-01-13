#!/bin/bash

packageManager=$1
workingDirectory=$2

# Burp Suite
if [[ -f "/usr/bin/burpsuite" ]]; then
	echo "Burp Suite is already installed."
else
	if [[ "$packageManager" = "apt" || "$packageManager" = "dnf" ]]; then
		echo "Support not yet added for apt and dnf"
	elif [[ "$packageManager" = "pacman" ]]; then
        cd ~/Downloads || return

        git clone https://aur.archlinux.org/burpsuite.git
        cd burpsuite || return
        makepkg -sri --noconfirm

        cd "$workingDirectory" || return
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
		sudo "$packageManager" install nmap -y
	fi
fi
