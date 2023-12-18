#!/bin/bash

packageManager=$1
workingDirectory=$2

# Terminator and zsh
terminalApps=("terminator" "zsh")
for terminalApp in ${terminalApps[@]}; do
    if [[ -f "/usr/bin/$terminalApp" ]]; then
        echo "$terminalApp is already installed."
    else
        if [[ "$packageManager" = "apt" || "$packageManager" = "dnf" ]]; then
            sudo $packageManager install "$terminalApp" -y
        if [[ "$packageManager" = "pacman" ]]; then
            sudo pacman -S --noconfirm "$terminalApp"
        else
            echo "Error Message"
        fi
    fi
done

# Change User Shells to Zsh
# TODO: Only run this if zsh is actually installed
chsh -s $(which zsh)
sudo chsh -s $(which zsh)

# Oh-my-zsh and Shell Configuration
if [[ -d "$HOME/.oh-my-zsh/" ]]; then
    echo "oh-my-zsh is already installed."
else
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    cd "$HOME/.oh-my-zsh/custom/plugins"
    git clone https://github.com/zsh-users/zsh-autosuggestions.git
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git

    cd "$workingDirectory"
    cat "$workingDirectory/src/config-files/zsh/zshrc.txt" > ~/.zshrc
fi

# Reload config file
source ~/.zshrc
