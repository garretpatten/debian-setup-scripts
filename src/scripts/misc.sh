#!/bin/bash

packageManager=$1

if [[ "$packageManager" = "dnf" ]]; then
	# Install Flatpak
	if [[ -f "/usr/bin/flatpak" ]]; then
		echo "flatpak is already installed."
	else
		sudo dnf install flatpak -y
	fi

	# Add remote Flatpak repos
	flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi

# Install Signal Messenger & Spotify
if [[ "$packageManager" = "dnf" ]]; then
	flatpakApps=("org.signal.Signal" "com.spotify.Client")
	for flatpakApp in ${flatpakApps[@]}; do
		if [[ -d "/var/lib/flatpak/app/$flatpakApp" ]]; then
			echo "$flatpak is already installed."
		elif [[ -d "$HOME/.local/share/flatpak/app/$flatpakApp" ]]; then
			echo "$flatpak is already installed."
		else
			flatpak install flathub "$flatpak" -y
		fi
	done
elif [[ "$packageManager" = "pacman" ]]; then
	apps=("signal-desktop" "spotify-launcher")
	for app in ${apps[@]}; do
		if [[ -d "/usr/bin/$app" ]]; then
			echo "$app is already installed."
		else
			echo y | sudo pacman -Syu "$app"
		fi
	done
elif [[ "$packageManager" = "apt" ]]; then
	echo "Support not yet added for apt."
else
	echo "Support for Signal and Spotify has only been added for dnf and pacman."
fi

# Thunderbird
if [[ -f "/usr/bin/thunderbird" ]]; then
 	echo "Thunderbird is already installed."
 else
	if [[ "$packageManager" = "pacman" ]]; then
		# TODO: Check if pacman install is possible
		echo y | yay -S "$cliTool"
	else
		sudo $packageManager install "$cliTool" -y
	fi
fi

# VLC
if [[ -f "/usr/bin/vlc" ]]; then
 	echo "VLC Media Player is already installed."
 else
	if [[ "$packageManager" = "dnf" ]]; then
		sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y
		sudo dnf install vlc -y
	elif [[ "$packageManager" = "pacman" ]]; then
		# TODO: Check if pacman install is possible
		echo y | yay -S "$cliTool"
	else
		# TODO: Add support for apt and
		echo "Support not yet added for apt."
	fi
fi