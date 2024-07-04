#!/bin/bash

### Configuration ###

# Git config
# TODO: Copy over from dotfiles
if [[ ! -f "$HOME/.gitconfig" ]]; then
    git config --global credential.helper store
    git config --global http.postBuffer 157286400
    git config --global pack.window 1
    git config --global user.email "garret.patten@proton.me"
    git config --global user.name "Garret Patten"
    git config --global pull.rebase false
fi

### Runtimes ###



# Neovim config
cp "$workingDirectory/src/dotfiles/nvim/init.vim" ~/.config/nvim/init.vim

# Vim config
cd "$workingDirectory" || return
cd src/dotfiles/vim/
cp .vimrc ~/.vimrc
cd .. || return
cd nvim
mkdir -p ~/.config/nvim/
cp init.vim ~/.config/nvim/init.vim
cd "$workingDirectory" || return

### Runtimes ###

# Node & npm
if [[ "$packageManager" = "apt-get" ]]; then
    # nosemgrep: bash.curl.security.curl-pipe-bash.curl-pipe-bash Installation comes from Debian docs
    curl -sL https://deb.nodesource.com/setup_18.x | sudo bash -
    sudo apt-get install nodejs -y
    #  NVM
    # nosemgrep: bash.curl.security.curl-pipe-bash.curl-pipe-bash Installation comes from Debian docs
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
fi

# Python & pip
if [[ ! -f "/usr/bin/python" || ! -f "usr/bin/python3" ]]; then
    sudo apt-get install python3.6 -y
    sudo apt-get install python3-pip -y
fi

### Frameworks ###

# Vue.js
if [[ ! -f "/usr/local/bin/vue" ]]; then
    sudo npm install -g @vue/cli
fi

### Dev Tools ###

# Docker and Docker-Compose
if [[ "$packageManager" = "apt-get" ]]; then
    sudo apt-get update -y
    sudo apt-get install apt-transport-https ca-certificates software-properties-common -y
    sudo apt-get install docker.io -y

    sudo apt-get install docker-compose -y
    docker image pull archlinux
    docker image pull fedora
fi

# GitHub CLI
if [[ ! -f "/usr/local/bin/gh" ]]; then
    sudo apt install gh -y
fi

# Postman
if [[ "$packageManager" = "dnf" ]]; then
    flatpak install flathub com.getpostman.Postman -y
fi

# Semgrep
if [[ ! -f "$HOME/.local/bin/semgrep" ]]; then
    python -m pip install semgrep
fi

# Shellcheck
if [[ "$packageManager" = "apt-get" ]]; then
    sudo apt install shellcheck -y
fi

# Sourcegraph
if [[ ! -f "/usr/local/bin/src" ]]; then
    curl -L https://sourcegraph.com/.api/src-cli/src_linux_amd64 -o "/usr/local/bin/src"
    chmod +x "/usr/local/bin/src"
fi

# VS Code
if [[ ! -f "/usr/bin/code" ]]; then
    isInstalled="true"
    if [[ "$packageManager" = "apt-get" ]]; then
        cd ~/Downloads || return

        wget "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
        wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg

        cd "$workingDirectory" || return

        sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
        sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

        sudo apt-get install apt-transport-https -y
        sudo apt-get update -y
        sudo apt-get install code -y
    elif [[ "$packageManager" = "dnf" ]]; then
        sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
        sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
        sudo dnf check-update -y
        sudo dnf install code -y
    elif [[ "$packageManager" = "pacman" ]]; then
        sudo pacman -S --noconfirm code
    else
        isInstalled="false"
        echo "VS Code $errorMessage"
    fi

    if [[ "$isInstalled" = "true" ]]; then
        cp "$workingDirectory/src/config-files/vs-code/settings.json" ~/.config/'Code - OSS'/User/settings.json
    fi
fi

### Fonts ###

# Fira Code
if [[ -d "/usr/share/fonts/FiraCode/" ]]; then
    echo "Fira Code is already installed."
    if [[ "$packageManager" = "pacman" ]]; then
        cd ~/Downloads || return

        git clone https://aur.archlinux.org/ttf-firacode.git
        cd ttf-firacode || return
        makepkg -sri --noconfirm

        cd "$workingDirectory" || return
    else
        echo "Fira Code $errorMessage"
    fi
fi

### Package Managers ###

# Packer installation
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 "$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim"
