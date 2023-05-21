#!/bin/bash

packageManager=$1

# Install basic CLI tools
cliTools=("bat" "curl" "exa" "git" "htop" "neofetch" "openvpn" "python3" "wget")
for cliTool in ${cliTools[@]}; do
	if [[ -d "/usr/bin/$cliTool" ]]; then
		echo "$cliTool is already installed."
	elif [[ -f "/usr/sbin/$cliTool" ]]; then
		echo "$cliTool is already installed."
	else
		if [[ "$packageManager" = "pacman" ]]; then
			echo y | sudo pacman -S "$cliTool"
		else
			sudo $packageManager install "$cliTool" -y
		fi
	fi
done
