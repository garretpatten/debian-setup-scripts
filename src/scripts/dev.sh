#!/bin/bash

# Git config
git config --global credential.helper cache
git config --global user.email "garret.patten@proton.me"
git config --global user.name "Garret Patten"
git config pull.rebase false

# Vim config
cat "$(pwd)/src/artifacts/vim/vimrc.txt" >> ~/.vimrc

# Install GitHub CLI && Sourcegraph CLI
apps=("gh" "src-cli")install
for app in ${apps[@]}; do
	if [[ -f "/usr/local/bin/$app" ]]; then
		echo "$app is already installed."
	else
		yay -S "$app"
	fi
done

if [[ -f "~/.local/bin/semgrep" ]]; then
	echo "Semgrep is already installed."
else
	python3 -m pip install semgrep

# # Install VS Code
# if [[ -f "/usr/bin/code" ]]; then
# 	echo "VS Code is already installed."
# else		
# 	sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
# 	sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
# 	sudo dnf check-update
# 	sudo dnf install code
# fi

# # Install Postman
# flatpak install flathub org.getpostman.Postman -y
