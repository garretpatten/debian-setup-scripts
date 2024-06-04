#!/bin/bash

errorMessage=$1
packageManager=$2

# Spotify
if [[ "$packageManager" = "apt-get" ]]; then
	if [[ -f "/usr/bin/spotify" || -f "/bin/spotify" ]]; then
		echo "Spotify is already installed."
	else
		sudo curl -sS https://download.spotify.com/debian/pubkey_6224F9941A8AA6D1.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
		echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
		sudo apt-get update -y && sudo apt-get install spotify-client -y
	fi
elif [[ "$packageManager" = "dnf" ]]; then
	if [[ -d "/var/lib/flatpak/app/org.spotify.Client" ]]; then
		echo "Spotify is already installed."
	elif [[ -d "$HOME/.local/share/flatpak/app/$flatpakApp" ]]; then
		echo "Spotify is already installed."
	else
		flatpak install flathub "$flatpakApp" -y
	fi
elif [[ "$packageManager" = "pacman" ]]; then
	if [[ -d "/usr/bin/$app" ]]; then
		echo "Spotify is already installed."
	else
		sudo pacman -S "spotify-launcher" --noconfirm
	fi
else
	echo "Spotify $errorMessage"
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
