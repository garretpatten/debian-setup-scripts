#!/bin/bash

packageManager=$1

# Git Config
if [[ ! -f "$HOME/.gitconfig" ]]; then
	git config --global credential.helper store
	git config --global user.email "garret.patten@proton.me"
	git config --global user.name "Garret Patten"
 	git config --global commit.gpgsign true
	# TODO: Does this need a --global flag?
	git config pull.rebase false
fi

# Vim Config
cat "$(pwd)/src/config-files/vim/vimrc.txt" >> ~/.vimrc

# Docker and Docker-Compose
# TODO: Eliminate duplicate lines
if [[ "$packageManager" = "apt" ]]; then
	sudo apt update -y
	sudo apt install apt-transport-https ca-certificates software-properties-common -y
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
	apt-cache policy docker-ce
	sudo apt install docker-ce -y
	sudo systemctl start docker.service
	sudo systemctl enable docker.service
	sudo usermod -aG docker $USER
	newgrp docker
	sudo apt install docker-compose -y
	docker image pull arch
	docker image pull fedora
elif [[ "$packageManager" = "dnf" ]]; then
	sudo dnf -y install dnf-plugins-core
	sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
	sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
	sudo systemctl start docker.service
	sudo systemctl enable docker.service
	sudo usermod -aG docker $USER
	newgrp docker
	sudo dnf install docker-compose -y
	docker iamge pull arch
	docker image pull ubuntu
elif [[ "$packageManager" = "pacman" ]]; then
	echo y | sudo pacman -S gnome-terminal
	echo y | sudo pacman -S docker
	sudo systemctl start docker.service
	sudo systemctl enable docker.service
	sudo usermod -aG docker $USER
	newgrp docker
	echo y | sudo pacman -S docker-compose
	docker iamge pull fedora
	docker image pull ubuntu
else
	echo "Support not yet added for this package manager."
if


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

# Vue.js
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
	isInstalled="yes"
	if [[ "$packageManager" = "apt" ]]; then
		currentPath=$(pwd)
		cd ~/Downloads

		wget https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64
		wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
		sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
		sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

		sudo apt install apt-transport-https -y
		sudo apt update -y
		sudo apt install code -y
	elif [[ "$packageManager" = "dnf" ]]; then
		sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
		sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
		sudo dnf check-update -y
		sudo dnf install code -y
	elif [[ "$packageManager" = "pacman" ]]; then
		echo y | sudo pacman -S code
	else
		isInstalled="no"
		echo "VS Code installations are only support for apt, dnf, and pacman."
	fi

	if [[ "$isInstalled" = "yes" ]]; then
		cp ../config-files/vs-code/settings.json ~/.config/'Code - OSS'/User/settings.json
	fi
fi

# Fira Code
if [[ -d "/usr/share/fonts/FiraCode/" ]]; then
	echo "Fira Code is already installed."
	if [[ "$packageManager" = "apt" ]]; then
		# TODO: Install Fira Code on apt
		echo "Support not yet added for apt."
	elif [[ "$packageManager" = "dnf" ]]; then
		# TODO: Install Fira Code on dnf
		echo "Support not yet added for dnf."
	elif [[ "$packageManager" = "pacman" ]]; then
		currentPath=$(pwd)
		cd ~/Downloads

		git clone https://aur.archlinux.org/ttf-firacode.git
		cd ttf-firacode
		echo y | makepkg -sri

		cd "$currentPath"
	else
		echo "Support is not yet added for this package manager."
	fi
fi
