#!/bin/bash

packageManager=$1

# Foundational CLI Tools
cliTools=("bat" "curl" "exa" "git" "htop" "neofetch" "openvpn" "wget")
for cliTool in ${cliTools[@]}; do
	if [[ -d "/usr/bin/$cliTool" ]]; then
		echo "$cliTool is already installed."
	elif [[ -f "/usr/sbin/$cliTool" ]]; then
		echo "$cliTool is already installed."
	else
		if [[ "$packageManager" = "apt" || "$packageManager" = "dnf" ]]; then
			sudo $packageManager install "$cliTool" -y
		elif [[ "$packageManager" = "pacman" ]]; then
			sudo pacman -S --noconfirm "$cliTool"
		else
			echo "Error Message"
		fi
	fi
done

# Python
if [[ -f "/usr/bin/python" ]]; then
	echo "python3 is already installed."
else
	if [[ "$packageManager" = "apt" ]]; then
		sudo apt install python3.6 -y
	elif [[ "$packageManager" = "dnf" ]]; then
		sudo dnf install python3 -y
	elif [[ "$packageManaer" = "pacman" ]]; then
		sudo pacman -S --noconfirm python3
	else
		echo "Support has only been added for apt, dnf, and pacman."
	fi
fi

# Pip
if [[ -f "/usr/bin/python-pip" ]]; then
	echo "python-pip is already installed."
else
	if [[ "$packageManager" = "apt" ]]; then
		sudo apt install python3-pip -y
	elif [[ "$packageManager" = "dnf" ]]; then
		sudo dnf install python3-pip -y
	elif [[ "$packageManager" = "pacman" ]]; then
		sudo pacman -S --noconfirm python-pip
	else
		echo "Support has only been added for apt, dnf, and pacman."
	fi
fi


