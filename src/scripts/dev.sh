#!/bin/bash

packageManager=$1

# Git Config
if [[ ! -f "$HOME/.gitconfig" ]]; then
	git config --global credential.helper store
	git config --global user.email "garret.patten@proton.me"
	git config --global user.name "Garret Patten"
	# TODO: Does this need a --global flag?
	git config pull.rebase false
fi

# Vim Config
cat "$(pwd)/src/artifacts/vim/vimrc.txt" >> ~/.vimrc

# Node.js
if [[ "$packageManager" = "dnf" ]]; then
	sudo dnf module install nodejs:18/common -y
elif [[ "$packageManager" = "pacman" ]]; then
	echo y | sudo pacman -S nodejs
	echo y | sudo pacman -S npm
else
	# TODO: Add support for apt
	echo "Support not yet added for apt."
fi

# Install Vue.js
if [[ -f "/usr/local/bin/vue" ]]; then
	echo "Vue is already installed."
else
	sudo npm install -g @vue/cli
fi


# GitHub CLI & Sourcegraph CLI
apps=("gh" "src-cli")
for app in ${apps[@]}; do
	if [[ -f "/usr/local/bin/$app" ]]; then
		echo "$app is already installed."
	else
		if [[ "$packageManager" = "pacman" ]]; then
			echo y | sudo pacman -S "$cliTool"
		else
			sudo $packageManager install "$cliTool" -y
		fi
	fi
done

# Semgrep
if [[ -f "$HOME/.local/bin/semgrep" ]]; then
	echo "Semgrep is already installed."
else
	# TODO: Fix for pacman
	python3 -m pip install semgrep
fi

# Postman
if [[ "$packageManager" = "pacman" ]]; then
	yay -S --noconfirm postman-bin
elif [[ "$packageManager" = "dnf" ]]; then
	flatpak install flathub com.getpostman.Postman -y
else
	# TODO: Add support for apt
	echo "Support not yet added for apt."
fi

# VS Code
if [[ -f "/usr/bin/code" ]]; then
	echo "VS Code is already installed."
else
	if [[ "$packageManager" = "apt" ]]; then
		$currentPath=$(pwd)
		cd ~/Downloads

		wget https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64
		wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
		sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
		sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

		sudo apt install apt-transport-https -y
		sudo apt update
		sudo apt install code -y
	elif [[ "$packageManager" = "dnf" ]]; then
		sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
		sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
		sudo dnf check-update -y
		sudo dnf install code -y
	elif [[ "$packageManager" = "pacman" ]]; then
		echo y | sudo pacman -S code
	else
		echo "VS Code installations are only support for apt, dnf, and pacman."
	fi
fi
