#!/bin/bash

workingDirectory=$1

### Authentication ###

# 1Password
if [[ ! -f "/usr/bin/1password" ]]; then
    if [[ "$packageManager" = "apt-get" ]]; then
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
        exit
    elif [[ "$packageManager" = "dnf" ]]; then
        # 1Password desktop app
        sudo rpm --import https://downloads.1password.com/linux/keys/1password.asc
        sudo sh -c 'echo -e "[1password]\nname=1Password Stable Channel\nbaseurl=https://downloads.1password.com/linux/rpm/stable/\$basearch\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=\"https://downloads.1password.com/linux/keys/1password.asc\"" > /etc/yum.repos.d/1password.repo'
        sudo dnf install 1password -y

        # 1Password CLI
        sudo rpm --import https://downloads.1password.com/linux/keys/1password.asc
        sudo sh -c 'echo -e "[1password]\nname=1Password Stable Channel\nbaseurl=https://downloads.1password.com/linux/rpm/stable/\$basearch\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=\"https://downloads.1password.com/linux/keys/1password.asc\"" > /etc/yum.repos.d/1password.repo'
        sudo dnf check-update -y 1password-cli && sudo dnf install 1password-cli
    fi
fi

# Hardware keys
if [[ "$packageManager" = "dnf" ]]; then
    if [[ -f "/usr/bin/pamu2fcfg" ]]; then
        echo "pam modules are already installed."
    else
        sudo dnf install pam pam-u2f pamu2fcfg -y
    fi

    if [[ ! -f "/etc/yubico/u2f_keys" ]]; then
        mkdir -p ~/.config/yubico

        printf "\n\n\nHardware Key Registration\n\n\n"

        # Register the primary key.
        pamu2fcfg >> ~/.config/yubico/u2f_keys

        # Register the backup key.
        pamu2fcfg >> ~/.config/yubico/u2f_keys

        sudo mkdir -p /etc/yubico
        sudo cp ~/.config/yubico/u2f_keys /etc/yubico/u2f_keys
        sudo chmod 644 /etc/yubico/u2f_keys

        # Authentication updates
        # TODO: Add python script to update /etc/pam.d/sudo to add: auth sufficient pam_u2f.so authfile=/etc/yubico/u2f_keys
    else
        echo "YubiKey file already configured. To re-configure, delete the etc config file and re-run."
    fi
else
    echo "Error Message."
fi

### Defense ###

# Clam AV
if [[ ! -f "/usr/bin/clamscan" ]]; then
    if [[ "$packageManager" = "dnf" ]]; then
        sudo dnf upgrade --refresh -y
        sudo dnf install clamav clamd clamav-update -y
    fi
fi

# Firewall
if [[ ! -f "/usr/sbin/ufw" ]]; then
    sudo "$packageManager" install ufw -y
fi
sudo ufw enable

### Privacy ###

# Proton VPN, Proton VPN CLI, and system tray icon
if [[ ! -f "/usr/bin/protonvpn" ]]; then
    if [[ "$packageManager" = "dnf" ]]; then
        cd ~/Downloads || return

        wget https://protonvpn.com/download/protonvpn-stable-release-1.0.1-1.noarch.rpm
        cd "$workingDirectory" || return
        sudo dnf install ~/Downloads/protonvpn-stable-release-1.0.1-1.noarch.rpm -y
        sudo dnf update -y
        sudo dnf install protonvpn-cli -y

        # Dependencies for alternative routing.
        sudo dnf install --user 'dnspython>=1.16.0' -y
    else
        # TODO: Add support for apt.
        echo "Support not yet added for apt."
    fi
fi

# Signal Messenger
if [[ "$packageManager" = "apt-get" ]]; then
	if [[ ! -f "/usr/bin/signal-desktop" || ! -f "/bin/signal-desktop" ]]; then
		wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > "$HOME/signal-desktop-keyring.gpg"
		tee < "$HOME/signal-desktop-keyring.gpg" /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null
		echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' | \
		sudo tee /etc/apt/sources.list.d/signal-xenial.list
		sudo apt-get update -y && sudo apt-get install signal-desktop -y
	fi
elif [[ "$packageManager" = "dnf" ]]; then
    if [[ ! -d "/var/lib/flatpak/app/org.signal.Signal" && ! -d "$HOME/.local/share/flatpak/app/org.signal.Signal" ]]; then
		flatpak install flathub "org.signal.Signal" -y
	fi
fi
