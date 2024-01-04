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

		# Create a break in output
		echo ""
		echo ""
		echo ""

		echo "Hardware Key Registration"

		# Create a break in output
		echo ""
		echo ""
		echo ""

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
		# 1Password Desktop
		sudo rpm --import https://downloads.1password.com/linux/keys/1password.asc
		sudo sh -c 'echo -e "[1password]\nname=1Password Stable Channel\nbaseurl=https://downloads.1password.com/linux/rpm/stable/\$basearch\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=\"https://downloads.1password.com/linux/keys/1password.asc\"" > /etc/yum.repos.d/1password.repo'
		sudo dnf install 1password -y

		# 1Password CLI
		sudo rpm --import https://downloads.1password.com/linux/keys/1password.asc
		sudo sh -c 'echo -e "[1password]\nname=1Password Stable Channel\nbaseurl=https://downloads.1password.com/linux/rpm/stable/\$basearch\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=\"https://downloads.1password.com/linux/keys/1password.asc\"" > /etc/yum.repos.d/1password.repo'
		sudo dnf check-update -y 1password-cli && sudo dnf install 1password-cli
	elif [[ "$packageManager" = "pacman" ]]; then
		currentPath=$(pwd)
		cd ~/Downloads

		# 1Password Desktop App
		curl -sS https://downloads.1password.com/linux/keys/1password.asc | gpg --import
		git clone https://aur.archlinux.org/1password.git
		cd 1password
		makepkg -sri --noconfirm

		# 1Password CLI
		ARCH="amd64" && \
		wget "https://cache.agilebits.com/dist/1P/op2/pkg/v2.23.0/op_linux_${ARCH}_v2.23.0.zip" -O op.zip && \
		unzip -d op op.zip && \
		sudo mv op/op /usr/local/bin && \
		rm -r op.zip op && \
		sudo groupadd -f onepassword-cli && \
		sudo chgrp onepassword-cli /usr/local/bin/op && \
		sudo chmod g+s /usr/local/bin/op

		cd "$currentPath"
	else
		# 1Password Desktop
		curl -sSO https://downloads.1password.com/linux/tar/stable/x86_64/1password-latest.tar.gz
		sudo tar -xf 1password-latest.tar.gz
		sudo mkdir -p /opt/1Password
		sudo mv 1password-*/* /opt/1Password
		sudo /opt/1Password/after-install.sh

		# 1Password CLI
		sudo su \
		curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
		gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
		echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main" | \
		tee /etc/apt/sources.list.d/1password.list
		mkdir -p /etc/debsig/policies/AC2D62742012EA22/
		curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | \
		tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
		mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
		curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
		gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg
		apt update -y && apt install 1password-cli -y
		exit
	fi
fi

# Proton VPN, Proton VPN CLI, and System Tray Icon
if [[ -f "/usr/bin/protonvpn" ]]; then
	echo "Proton VPN is already installed."
else
	if [[ "$packageManager" = "dnf" ]]; then
		currentPath=$(pwd)
		cd ~/Downloads

		wget https://protonvpn.com/download/protonvpn-stable-release-1.0.1-1.noarch.rpm
		sudo dnf install ~/Downloads/protonvpn-stable-release-1.0.1-1.noarch.rpm -y
		sudo dnf update -y
		sudo dnf install protonvpn-cli -y

		# Dependencies for Alternative Routing
		sudo dnf install --user 'dnspython>=1.16.0' -y
	elif [[ "$packageManager" = "pacman" ]]; then
		yay -S --no-confirm protonvpn
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
