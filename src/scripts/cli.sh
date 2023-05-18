#!/bin/bash

# Install basic CLI tools
cliTools=("bat" "curl" "exa" "git" "https" "htop" "neofetch" "openvpn" "wget")
for cliTool in ${cliTools[@]}; do
	if [[ -d "/usr/bin/$cliTool/" ]]; then
		echo "$cliTool is already installed."
	elif [ -f "/usr/sbin/$cliTool"]; then
		echo "$cliTool is already installed."
	else
		sudo dnf install "$cliTool" -y
	fi
done
