#!/bin/bash

packageManager=$1

# Install Terminator and zsh
terminalApps=("terminator" "zsh")
for terminalApp in ${terminalApps[@]}; do
    if [[ -f "/usr/bin/$terminalApp" ]]; then
        echo "$terminalApp is already installed."
    else
        if [[ "$packageManager" = "pacman" ]]; then
            echo y | sudo pacman -S terminalApp
        else
            sudo $packageManager install "$cliTool" -y
        fi
    fi
done

# Change User Shells to Zsh
chsh -s $(which zsh)
sudo chsh -s $(which zsh)

# Install oh-my-zsh and configure shell
if [[ -d "~/.oh-my-zsh/" ]]; then
    echo "oh-my-zsh is already installed."
else
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    currentPath=$(pwd)
    cd ~/.oh-my-zsh/custom/plugins
    git clone https://github.com/zsh-users/zsh-autosuggestions.git
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git

    cd $currentPath
    cat "$(pwd)/src/artifacts/zsh/zshrc.txt" > ~/.zshrc
fi

# Reload config file
source ~/.zshrc
