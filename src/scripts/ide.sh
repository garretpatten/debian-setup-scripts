#!/bin/bash

workingDirectory=$1

# Configure vim
if [[ ! -f "$HOME/.vimrc" ]]; then
    cp "$workingDirectory/src/dotfiles/vim/.vimrc" "$HOME/.vimrc"
fi

# Neovim setup
if [[ ! -d "$HOME/.config/nvim/" ]]; then
    mkdir -p "$HOME/.config/"
    cp -r "$workingDirectory/src/dotfiles/nvim/" "$HOME/.config/nvim/"
    git clone --depth 1 https://github.com/wbthomason/packer.nvim \
    "$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim"
    sudo apt install tree-sitter-cli -y
fi

# VS Code
if [[ ! -f "/usr/bin/code" ]]; then
    cd "$HOME/Downloads" || return

    wget "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg

    cd "$workingDirectory" || return

    sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
    sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

    sudo apt-get install apt-transport-https -y
    sudo apt-get update -y
    sudo apt-get install code -y
fi
