#!/bin/bash

errorMessage=$1
packageManager=$2

# Signal Messenger & Spotify
if [[ "$packageManager" = "apt-get" ]]; then
	# TODO: Add support for apt
	echo "Support not yet added for apt."
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
		# TODO: Add support for apt
		echo "Support not yet added for apt."
	elif [[ "$packageManager" = "dnf" ]]; then
		sudo dnf install "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" -y
		sudo dnf install "$app" -y
	elif [[ "$packageManager" = "pacman" ]]; then
		sudo pacman -S --noconfirm "$app"
	else
		echo "$app $errorMessage"
	fi
fi
