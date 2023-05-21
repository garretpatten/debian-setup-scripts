#!/bin/bash

packageManager=$1

# Git config
if [[ ! -f "$HOME/.gitconfig" ]]; then
	git config --global credential.helper store
	git config --global user.email "garret.patten@proton.me"
	git config --global user.name "Garret Patten"
	git config pull.rebase false
fi

# Vim config
cat "$(pwd)/src/artifacts/vim/vimrc.txt" >> ~/.vimrc

# Install GitHub CLI & Sourcegraph CLI
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

if [[ -f "$HOME/.local/bin/semgrep" ]]; then
	echo "Semgrep is already installed."
else
	python3 -m pip install semgrep
fi

# Install VS Code
if [[ -f "/usr/bin/code" ]]; then
	echo "VS Code is already installed."
else
	if [[ "$packageManager" = "pacman" ]]; then
		echo y | sudo pacman -S code
	elif [[ "$packageManager" = "dnf" ]]; then
		sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
		sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
		sudo dnf check-update -y
		sudo dnf install code -y
	else
		# TODO: Add support for apt
		echo "Support not yet added for apt."
	fi
fi

# Install Postman
if [[ "$packageManager" = "pacman" ]]; then
	echo y | yay -S postman-bin
	# TODO: Automate 2 Enter keypresses & Y parameter
elif [[ "$packageManager" = "dnf" ]]; then
	flatpak install flathub com.getpostman.Postman -y
else
	# TODO: Add support for apt
	echo "Support not yet added for apt."
fi