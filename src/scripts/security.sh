#!/bin/bash

workingDirectory=$1

### Authentication ###

# 1Password
if [[ ! -f "/usr/bin/1password" ]]; then
    # 1Password desktop app
    curl -sSO https://downloads.1password.com/linux/tar/stable/x86_64/1password-latest.tar.gz
    sudo tar -xf 1password-latest.tar.gz
    sudo mkdir -p /opt/1Password
    sudo mv 1password-*/* /opt/1Password
    sudo /opt/1Password/after-install.sh

    # 1Password CLI
    sudo curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
    sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
    sudo echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main" | \
    sudo tee /etc/apt/sources.list.d/1password.list
    sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
    sudo curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | \
    sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
    sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
    sudo curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
    sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg
    sudo apt-get update -y && sudo apt-get install 1password-cli -y
fi

# TODO: Add hardware keys auth for system

### Defense ###

# Clam AV
if [[ ! -f "/usr/bin/clamscan" ]]; then
    # TODO: Install clamscan
fi

# Firewall
if [[ ! -f "/usr/sbin/ufw" ]]; then
    sudo apt install ufw -y
fi
sudo ufw enable

### Privacy ###

# Proton VPN, Proton VPN CLI, and system tray icon
if [[ ! -f "/usr/bin/protonvpn" ]]; then
    wget https://repo.protonvpn.com/debian/dists/stable/main/binary-all/protonvpn-stable-release_1.0.8_all.deb
    sudo dpkg -i ./protonvpn-stable-release_1.0.8_all.deb && sudo apt update
    echo "0b14e71586b22e498eb20926c48c7b434b751149b1f2af9902ef1cfe6b03e180 protonvpn-stable-release_1.0.8_all.deb" | sha256sum --check -
    sudo apt install proton-vpn-gnome-desktop -y
    sudo apt install libayatana-appindicator3-1 gir1.2-ayatanaappindicator3-0.1 gnome-shell-extension-appindicator
fi

# Signal Messenger
if [[ ! -f "/usr/bin/signal-desktop" && ! -f "/bin/signal-desktop" ]]; then
    wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > "$HOME/signal-desktop-keyring.gpg"
    tee < "$HOME/signal-desktop-keyring.gpg" /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null
    echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' | \
    sudo tee /etc/apt/sources.list.d/signal-xenial.list
    sudo apt-get update -y
    sudo apt-get install signal-desktop -y
fi
