#!/bin/bash

packageManager=$1

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
# TODO: Below line is failing to parse
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y
sudo dnf install vlc -y
if [[ -f "/usr/bin/vlc" ]]; then
 	echo "VLC Media Player is already installed."
 else
	if [[ "$packageManager" = "dnf" ]]; then
		sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y
		sudo dnf install vlc -y
	else if [[ "$packageManager" = "pacman" ]]; then
		# TODO: Check if pacman install is possible
		echo y | yay -S "$cliTool"
	else
		# TODO: Add support for apt and deb
		echo "Support not yet added for apt and deb."
	fi
fi