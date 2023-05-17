#!/bin/bash

# Git config
if ! [[ -f "~/.gitconfig" ]]; then
	git config --global credential.helper store
	git config --global user.email "garret.patten@proton.me"
	git config --global user.name "Garret Patten"
	git config pull.rebase false
fi

# Vim config
cat "$(pwd)/src/artifacts/vim/vimrc.txt" >> ~/.vimrc

# Install GitHub CLI && Sourcegraph CLI
apps=("gh" "src-cli")install
for app in ${apps[@]}; do
	if [[ -f "/usr/local/bin/$app" ]]; then
		echo "$app is already installed."
	else
		echo y | yay -S "$app"
	fi
done

if [[ -f "~/.local/bin/semgrep" ]]; then
	echo "Semgrep is already installed."
else
	python3 -m pip install semgrep

# Install VS Code
if [[ -f "/usr/bin/code" ]]; then
	echo "VS Code is already installed."
else		
	echo y | sudo pacman -S code

# Install Postman
yay -S postman-bin
# TODO: Automate 2 Enter keypresses & Y parameter
