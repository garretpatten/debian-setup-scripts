#!/bin/bash

errorMessage=$1
packageManager=$2
workingDirectory=$3

# Terminator and zsh.
terminalApps=("terminator" "zsh")
for terminalApp in "${terminalApps[@]}"; do
    if [[ -f "/usr/bin/$terminalApp" ]]; then
        echo "$terminalApp is already installed."
    else
        if [[ "$packageManager" = "apt-get" || "$packageManager" = "dnf" ]]; then
            sudo "$packageManager" install "$terminalApp" -y
        elif [[ "$packageManager" = "pacman" ]]; then
            sudo pacman -S --noconfirm "$terminalApp"
        else
            echo "$terminalApp $errorMessage"
        fi
    fi
done

# Change user shells to zsh.
if [[ -f "/usr/bin/zsh" ]]; then
    chsh -s "$(which zsh)"
    sudo chsh -s "$(which zsh)"
fi

# Oh-my-zsh and shell configuration.
if [[ -d "$HOME/.oh-my-zsh/" ]]; then
    echo "oh-my-zsh is already installed."
else
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    cd "$HOME/.oh-my-zsh/custom/plugins" || return
    git clone https://github.com/zsh-users/zsh-autosuggestions.git
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git

    cd "$workingDirectory" || return
    cp "$workingDirectory/src/config-files/zsh/zshrc.txt" ~/.zshrc

    # Reload config file.
    omz reload
fi

