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
    # nosemgrep: bash.curl.security.curl-pipe-bash.curl-pipe-bash Installation comes from oh my zsh docs
    terminator -x bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    check_before_proceeding() {
        while true; do
		read -p "/n/n/noh-my-zsh installation must complete before the script proceeds. Has oh-my-zsh finished installing? (Y/n): " user_input
		case $user_input in
                    [Yy]* ) 
                        echo "Proceeding..."
                        break
                        ;;
                    [Nn]* ) 
                        echo "Please enter 'Y' to proceed."
                        ;;
                    * ) 
                        echo "Invalid input. Please enter 'Y' or 'n'."
                        ;;
                esac
        done
    }


    check_before_proceeding
    echo "Continuing with the script..."
fi

# Install plugins and update .zshrc if needed
if [[ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" || ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]]; then

    cd "$HOME/.oh-my-zsh/custom/plugins" || return
    git clone https://github.com/zsh-users/zsh-autosuggestions.git
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git

    cd "$workingDirectory" || return
    cd src/config-files/zsh/
    cp .zshrc ~/.zshrc
    cd "$workingDirectory" || return
fi

