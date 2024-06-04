#!/bin/bash

errorMessage=$1
packageManager=$2
workingDirectory=$3

### Payloads ###

# Payloads All the Things
git clone https://github.com/swisskyrepo/PayloadsAllTheThings ~/Hacking

# SecLists
git clone https://github.com/danielmiessler/SecLists ~/Hacking

### Tools ###

# Black Arch tools
if [[ "$packageManager" = "pacman" ]]; then
    curl -O https://blackarch.org/strap.sh
    chmod +x strap.sh
    sudo ./strap.sh
else
    echo "Black Arch tools $errorMessage"
fi

# Burp Suite
if [[ -f "/usr/bin/burpsuite" ]]; then
    echo "Burp Suite is already installed."
else
    if [[ "$packageManager" = "pacman" ]]; then
        cd ~/Downloads || return

        git clone https://aur.archlinux.org/burpsuite.git
        cd burpsuite || return
        makepkg -sri --noconfirm

        cd "$workingDirectory" || return
    else
        echo "Burp Suite $errorMessage"
    fi
fi

# Network Mapper
if [[ -f "/usr/bin/nmap" ]]; then
    echo "Network Mapper is already installed."
else
    if [[ "$packageManager" = "apt-get" || "$packageManager" = "dnf" ]]; then
        sudo "$packageManager" install nmap -y
    elif [[ "$packageManager" = "pacman" ]]; then
        sudo pacman -S --noconfirm nmap
    else
        echo "nmap $errorMessage"
    fi
fi

# ZAP
if [[ "$packageManager" = "apt-get" || "$packageManager" = "dnf" ]]; then
    flatpak install flathub org.zaproxy.ZAP
elif [[ "$packageManager" = "pacman" ]]; then
    sudo pacman -S zaproxy --noconfirm
else
    echo "ZAProxy $errorMessage"
fi
