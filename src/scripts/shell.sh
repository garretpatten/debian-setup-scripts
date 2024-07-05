#!/bin/bash

workingDirectory=$1

# Terminator and zsh.
terminalApps=("terminator" "zsh")
for terminalApp in "${terminalApps[@]}"; do
    sudo "$packageManager" install "$terminalApp" -y
done

# Change user shells to zsh.
if [[ -f "/usr/bin/zsh" ]]; then
    sudo chsh -s "$(which zsh)"
fi
