# #!/bin/bash

# # Install packages for YubiKeys
# if [[ -f "/usr/bin/pamu2fcfg" ]]; then
#     echo "pam modules are already installed."
# else
#     sudo dnf install pam pam-u2f pamu2fcfg -y
# fi

# # Create local directory for key registration
# mkdir -p ~/.config/yubico

# # Create a break in output
# echo ''
# echo ''
# echo ''

# echo "Hardware Key Registration"

# # Create a break in output
# echo ''
# echo ''
# echo ''

# # Register primary key
# pamu2fcfg >> ~/.config/yubico/u2f_keys

# # Register backup key
# pamu2fcfg >> ~/.config/yubico/u2f_keys

# # Create directory in /etc/ for key registration
# sudo mkdir -p /etc/yubico

# # Copy keys to directory
# sudo cp ~/.config/yubico/u2f_keys /etc/yubico/u2f_keys

# # Update keys file permissions to make it readable
# sudo chmod 644 /etc/yubico/u2f_keys

# Authentication Updates
# TODO: Add python script to update /etc/pam.d/sudo to add: auth sufficient pam_u2f.so authfile=/etc/yubico/u2f_keys

# Install and Enable Firewall
if [[ -f "/usr/sbin/ufw" ]]; then
    echo "Firewall is already installed."
else
    echo y | sudo pacman -S ufw 
fi
sudo ufw enable

# Install 1Password
if [[ -f "/usr/bin/1password" ]]; then
    echo "1Password is already installed."
else
    currentPath=$(pwd)
    cd

    if [[ -d "~/Downloads" ]]; then
        mkdir Downloads
    fi
    cd Downloads

    curl -sSO https://downloads.1password.com/linux/tar/stable/x86_64/1password-latest.tar.gz
    sudo tar -xf 1password-latest.tar.gz
    sudo mkdir -p /opt/1Password
    sudo mv 1password-*/* /opt/1Password
    sudo /opt/1Password/after-install.sh

    cd $currentPath
fi

# TODO: Install Proton VPN Client, CLI tool, and System Tray Icon
yay -S protonvpn
# TODO: Automate 2 Enter keypresses & y parameter & 8 Y parameters
echo y | sudo pacman -S libappindicator-gtk3 gnome-shell-extension-appindicator

# Install Clam AV
if [[ -f "/usr/bin/clamscan" ]]; then
    echo "Clam Anti-Virus is already installed."
else  
    echo y | sudo pacman -S clamav
fi

# Install nmap
if [[ -f "/usr/bin/nmap" ]]; then
    echo "nmap is already installed."
else
    echo y | sudo pacman -S nmap
fi
