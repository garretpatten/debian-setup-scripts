#!/bin/bash

errorMessage=$1
packageManager=$2

# Signal Messenger and Spotify
if [[ "$packageManager" = "apt-get" ]]; then
	if [[ -f "/usr/bin/signal-desktop" || -f "/bin/signal-desktop" ]]; then
		echo "Signal is already installed."
	else
		wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > "$HOME/signal-desktop-keyring.gpg"
		tee < "$HOME/signal-desktop-keyring.gpg" /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null
		echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' | \
		sudo tee /etc/apt/sources.list.d/signal-xenial.list
		sudo apt-get update -y && sudo apt-get install signal-desktop -y
	fi

	if [[ -f "/usr/bin/spotify" || -f "/bin/spotify" ]]; then
		echo "Spotify is already installed."
	else
		sudo curl -sS https://download.spotify.com/debian/pubkey_6224F9941A8AA6D1.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
		echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
		sudo apt-get update -y && sudo apt-get install spotify-client -y
	fi
elif [[ "$packageManager" = "dnf" ]]; then
	flatpakApps=("org.signal.Signal" "com.spotify.Client")
	for flatpakApp in "${flatpakApps[@]}"; do
		if [[ -d "/var/lib/flatpak/app/$flatpakApp" ]]; then
			echo "$flatpakApp is already installed."
		elif [[ -d "$HOME/.local/share/flatpak/app/$flatpakApp" ]]; then
			echo "$flatpakApp is already installed."
		else
			flatpak install flathub "$flatpakApp" -y
		fi
	done
elif [[ "$packageManager" = "pacman" ]]; then
	apps=("signal-desktop" "spotify-launcher")
	for app in "${apps[@]}"; do
		if [[ -d "/usr/bin/$app" ]]; then
			echo "$app is already installed."
		else
			sudo pacman -S --noconfirm "$app"
		fi
	done
else
	echo "$app $errorMessage"
fi

# Thunderbird
if [[ -f "/usr/bin/thunderbird" ]]; then
	echo "Thunderbird is already installed."
else
	app="thunderbird"
	if [[ "$packageManager" = "apt-get" || "$packageManager" = "dnf" ]]; then
		sudo "$packageManager" install "$app" -y
	elif [[ "$packageManager" = "pacman" ]]; then
		sudo pacman -S --noconfirm "$app"
	else
		echo "$app $errorMessage"
	fi
fi

# VLC
if [[ -f "/usr/bin/vlc" ]]; then
	echo "VLC Media Player is already installed."
else
	app="vlc"
	if [[ "$packageManager" = "apt-get" ]]; then
		sudo apt-get install "$app" -y
	elif [[ "$packageManager" = "dnf" ]]; then
		sudo dnf install "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" -y
		sudo dnf install "$app" -y
	elif [[ "$packageManager" = "pacman" ]]; then
		sudo pacman -S --noconfirm "$app"
	else
		echo "$app $errorMessage"
	fi
fi
