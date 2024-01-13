#!/bin/bash

packageManager=$1

# Flatpak
if [[ "$packageManager" = "apt" || "$packageManager" = "dnf" ]]; then
	if [[ -f "/usr/bin/flatpak" ]]; then
		echo "flatpak is already installed."
	else
		sudo $packageManager install flatpak -y
	fi

	# Add remote Flathub repos
	flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi

# Signal Messenger & Spotify
if [[ "$packageManager" = "apt" ]]; then
	# TODO: Add support for apt
	echo "Support not yet added for apt."
elif [[ "$packageManager" = "dnf" ]]; then
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
			sudo pacman -S --noconfirmyu "$app"
		fi
	done
else
	echo "Error Message."
fi

# Thunderbird
if [[ -f "/usr/bin/thunderbird" ]]; then
	echo "Thunderbird is already installed."
else
	cliTool = "thunderbird"
	if [[ "$packageManager" = "apt" || "$packageManager" = "dnf" ]]; then
		sudo $packageManager install "$cliTool" -y
	elif [[ "$packageManager" = "pacman" ]]; then
		sudo pacman -S --noconfirm "$cliTool"
	else
		echo "Error Message"
	fi
fi

# VLC
if [[ -f "/usr/bin/vlc" ]]; then
	echo "VLC Media Player is already installed."
else
	cliTool="vlc"
	if [[ "$packageManager" = "apt" ]]; then
		# TODO: Add support for apt
		echo "Support not yet added for apt."
	elif [[ "$packageManager" = "dnf" ]]; then
		sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y
		sudo dnf install vlc -y
	elif [[ "$packageManager" = "pacman" ]]; then
		sudo pacman -S --noconfirm "$cliTool"
	else
		echo "Error Message"
	fi
fi
