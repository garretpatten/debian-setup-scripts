#!/bin/bash

workingDirectory=$1

# Taskwarrior
if [[ ! -f "/usr/bin/task" ]]; then
    sudo apt install "taskwarrior" -y

    # Handle first Taskwarrior prompt (to create config file).
    echo "yes" | task

    # Add manual setup tasks.
    task add Install Timeshift project:setup priority:H
    task add Remove unneeded update commands from .zshrc project:setup priority:H
    task add Take a snapshot of system project:setup priority:H
    task add Update .zshrc project:dev priority:H

    task add Sign into and sync Brave project:setup priority:M
    task add Configure 1Password project:setup priority:M

    task add Install Burp Suite project:setup priority:L
    task add Download needed files from Proton Drive project:setup priority:L
fi

# Taskwarrior config
cat "$workingDirectory/src/config-files/taskwarrior/taskrcUpdates.txt" >> "$HOME/.taskrc"

# Add custom themes
if [[ ! -d "$HOME/.task/themes/" ]]; then
    mkdir ~/.task/themes/
    cp -r "$workingDirectory/src/config-files/taskwarrior/themes/" "$HOME/.task/themes/"
fi

# Timeshift
if [[ ! -f "/usr/bin/timeshift" ]]; then
    sudo apt install timeshift -y
fi
