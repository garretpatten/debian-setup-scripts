#!/bin/bash

packageManager=$1

# Setup YubiKeys
if [[ "$packageManager" = "dnf" ]]; then
	if [[ -f "/usr/bin/pamu2fcfg" ]]; then
		echo "pam modules are already installed."
	else
		sudo dnf install pam pam-u2f pamu2fcfg -y
	fi

	if [[ ! -f "/etc/yubico/u2f_keys" ]]; then
		mkdir -p ~/.config/yubico

		echo ''
		echo ''
		echo ''

		echo "Hardware Key Registration"

		echo ''
		echo ''
		echo ''

		# Register Primary Key
		pamu2fcfg >> ~/.config/yubico/u2f_keys

		# Register Backup Key
		pamu2fcfg >> ~/.config/yubico/u2f_keys

		sudo mkdir -p /etc/yubico
		sudo cp ~/.config/yubico/u2f_keys /etc/yubico/u2f_keys
		sudo chmod 644 /etc/yubico/u2f_keys

		# Authentication Updates
		# TODO: Add python script to update /etc/pam.d/sudo to add: auth sufficient pam_u2f.so authfile=/etc/yubico/u2f_keys
	else
		echo "YubiKey file already configured. To re-configure, delete the etc config file and re-run."
	fi
else
	echo "Support not yet added for apt and pacman."
fi

# Enable Firewall
if [[ -f "/usr/sbin/ufw" ]]; then
	echo "Firewall is already installed."
else
	if [[ "$packageManager" = "pacman" ]]; then
		echo y | sudo pacman -S ufw
	else
		sudo $packageManager install ufw -y
	fi
fi
sudo ufw enable

# 1Password
if [[ -f "/usr/bin/1password" ]]; then
	echo "1Password is already installed."
else
	if [[ "$packageManager" = "dnf" ]]; then
		sudo rpm --import https://downloads.1password.com/linux/keys/1password.asc
		sudo sh -c 'echo -e "[1password]\nname=1Password Stable Channel\nbaseurl=https://downloads.1password.com/linux/rpm/stable/\$basearch\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=\"https://downloads.1password.com/linux/keys/1password.asc\"" > /etc/yum.repos.d/1password.repo'
		sudo dnf install 1password -y
	elif [[ "$packageManager" = "pacman" ]]; then
		# TODO: Add Arch stuff
		currentPath=$(pwd)
		cd ~/Downloads

		curl -sSO https://downloads.1password.com/linux/tar/stable/x86_64/1password-latest.tar.gz
		sudo tar -xf 1password-latest.tar.gz
		sudo mkdir -p /opt/1Password
		sudo mv 1password-*/* /opt/1Password
		sudo /opt/1Password/after-install.sh

		cd $currentPath
	else
		# TODO: Add support for apt
		echo "Support not yet added for apt."
	fi
fi

# Proton VPN, Proton VPN CLI, and System Tray Icon
# TODO: Check location of Proton VPN
if [[ -f "/usr/bin/protonvpn" ]]; then
	echo "Proton VPN is already installed."
else
	if [[ "$packageManager" = "dnf" ]]; then
		# Download and Install RPM Package
		# TODO: Download RPM Package from https://protonvpn.com/download/protonvpn-stable-release-1.0.1-1.noarch.rpm
		sudo dnf install ~/Downloads/protonvpn-stable-release-1.0.1-1.noarch.rpm -y
		sudo dnf update -y
		sudo dnf install protonvpn-cli -y

		# Dependencies for Alternative Routing
		sudo dnf install python3-pip -y
		sudo dnf install --user 'dnspython>=1.16.0' -y
	elif [[ "$packageManager" = "pacman" ]]; then
		yay -S protonvpn
		# TODO: Automate 2 Enter keypresses & y parameter & 8 Y parameters
		echo y | sudo pacman -S libappindicator-gtk3 gnome-shell-extension-appindicator
	else
		# TODO: Add support for apt
		echo "Support not yet added for apt."
	fi
fi

# Clam AV
if [[ -f "/usr/bin/clamscan" ]]; then
	echo "Clam Anti-Virus is already installed."
else
	if [[ "$packageManager" = "dnf" ]]; then
		sudo dnf upgrade --refresh -y
		sudo dnf install clamav clamd clamav-update -y
	elif [[ "$packageManager" = "pacman" ]]; then
		echo y | sudo pacman -S clamav
	else
		# TODO: Add support for apt
		echo "Support not yet added for apt."
	fi
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
