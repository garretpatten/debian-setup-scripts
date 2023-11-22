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
		if [[ "$packageManager" = "pacman" ]]; then
			echo y | sudo pacman -S "$cliTool"
		else
			sudo $packageManager install "$cliTool" -y
		fi
	fi
done

# Python
if [[ -f "/usr/bin/python" ]]; then
	echo "python3 is already installed."
else
	if [[ "$packageManager" = "dnf" ]]; then
		sudo dnf install python3 -y
	elif [[ "$packageManaer" = "pacman" ]]; then
		echo y | sudo pacman -S python3
	elif [[ "$packageManager" = "apt" ]]; then
		sudo apt install python3.6 -y
	else
		echo "Support has only been added for apt, dnf, and pacman."
	fi
fi

# Pip
if [[ -f "/usr/bin/python-pip" ]]; then
	echo "python-pip is already installed."
else
	if [[ "$packageManager" = "dnf" ]]; then
		sudo dnf install python3-pip -y
	elif [[ "$packageManager" = "pacman" ]]; then
		echo y | sudo pacman -S python-pip
	elif [[ "$packageManager" = "apt" ]]; then
		sudo apt install python3-pip -y
	else
		echo "Support has only been added for apt, dnf, and pacman."
	fi
fi


