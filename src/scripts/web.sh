#!/bin/bash

packageManager=$1

# Brave
if [[ -f "/usr/bin/brave-browser" ]]; then
    echo "Braver browser is already installed."
else
    if [[ "$packageManager" = "dnf" ]]; then
        sudo dnf install dnf-plugins-core -y
        sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
        sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
        sudo dnf install brave-browser -y
    elif [[ "$packageManager" = "pacman" ]]; then
        yay -S --noconfirm brave-bin
    else
        sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
        echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
        sudo apt update -y
        sudo apt install brave-browser -y
    fi
fi
