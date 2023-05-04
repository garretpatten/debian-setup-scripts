#!/bin/bash

# Install packages for YubiKeys
if [[ -f "/usr/bin/pamu2fcfg" ]]; then
    echo "pam modules are already installed."
else
    sudo dnf install pam pam-u2f pamu2fcfg -y
fi

# Create local directory for key registration
mkdir -p ~/.config/yubico

# Create a break in output
echo ''
echo ''
echo ''

echo "Hardware Key Registration"

# Create a break in output
echo ''
echo ''
echo ''

# Register primary key
pamu2fcfg >> ~/.config/yubico/u2f_keys

# Register backup key
pamu2fcfg >> ~/.config/yubico/u2f_keys

# Create directory in /etc/ for key registration
sudo mkdir -p /etc/yubico

# Copy keys to directory
sudo cp ~/.config/yubico/u2f_keys /etc/yubico/u2f_keys

# Update keys file permissions to make it readable
sudo chmod 644 /etc/yubico/u2f_keys

# Authentication Updates
# TODO: Add python script to update /etc/pam.d/sudo to add: auth sufficient pam_u2f.so authfile=/etc/yubico/u2f_keys

# Install and Enable Firewall
if [[ -f "/usr/sbin/ufw" ]]; then
    echo "Firewall is already installed."
else
    sudo dnf install ufw -y
fi
sudo ufw enable

## Install 1Password
if [[ -f "/usr/bin/1password" ]]; then
    echo "1Password is already installed."
else
    sudo rpm --import https://downloads.1password.com/linux/keys/1password.asc
    sudo sh -c 'echo -e "[1password]\nname=1Password Stable Channel\nbaseurl=https://downloads.1password.com/linux/rpm/stable/\$basearch\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=\"https://downloads.1password.com/linux/keys/1password.asc\"" > /etc/yum.repos.d/1password.repo'
    sudo dnf install 1password -y
fi

# TODO: Install Proton VPN

# Download and Install RPM Package
# TODO: Download RPM Package from https://protonvpn.com/download/protonvpn-stable-release-1.0.1-1.noarch.rpm
sudo dnf install ~/Downloads/protonvpn-stable-release-1.0.1-1.noarch.rpm -y
sudo dnf update -y
sudo dnf install protonvpn-cli -y

# Dependencies for Alternative Routing
sudo dnf install python3-pip -y
sudo dnf install --user 'dnspython>=1.16.0' -y

# Install Clam AV
if [[ -f "/usr/bin/clamscan" ]]; then
    echo "Clam Anti-Virus is already installed."
else  
    sudo dnf upgrade --refresh -y
    sudo dnf install clamav clamd clamav-update -y
fi

# Install nmap
if [[ -f "/usr/bin/clamscan" ]]; then
    echo "nmap is already installed."
else
    sudo dnf install nmap -y
fi
