#!/bin/bash

errorMessage=$1
packageManager=$2
workingDirectory=$3

# Taskwarrior
if [[ -f "/usr/bin/task" ]]; then
    echo "Taskwarrior is already installed."
else
    task="task"
    if [[ "$packageManager" = "apt-get" ]]; then
        sudo "$packageManager" install "taskwarrior" -y
    elif [[ "$packageManager" = "dnf" ]]; then
        sudo "$packageManager" install "$task" -y
    elif [[ "$packageManager" = "pacman" ]]; then
        sudo pacman -S "$task" --noconfirm
    else
        echo "Error Message"
    fi

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
cp "$workingDirectory/src/config-files/taskwarrior/taskrcUpdates.txt" ~/.taskrc

# Add custom themes directory.
if [[ -d "$HOME/.task/themes/" ]]; then
    echo "Taskwarrior themes directory already exists."
else
    mkdir ~/.task/themes/
fi

# Add custom themes.
cp -r "$workingDirectory/src/config-files/taskwarrior/themes/" ~/.task/themes/

# Notion, Simplenote, and Todoist
if [[ "$packageManager" = "apt-get" || "$packageManager" = "dnf" ]]; then
    if [[ "$packageManager" = "apt-get" ]]; then
        echo "deb [trusted=yes] https://apt.fury.io/notion-repackaged/ /" | sudo tee /etc/apt/sources.list.d/notion-repackaged.list
        sudo apt-get update -y
        sudo apt-get install notion-app-enhanced -y
        sudo apt-get install notion-app
    else
        printf "[notion-repackaged]\nname=notion-repackaged\nbaseurl=https://yum.fury.io/notion-repackaged/\nenabled=1\ngpgcheck=0" > /etc/yum.repos.d/notion-repackaged.repo
        sudo dnf install notion-app -y
    fi

    flatpakApps=("com.simplenote.Simplenote" "com.todoist.Todoist")
    for flatpakApp in "${flatpakApps[@]}"; do
        if [[ -d "/var/lib/flatpak/app/$flatpakApp" ]]; then
            echo "$flatpakApp is already installed."
        elif [[ -d "$HOME/.local/share/flatpak/app/$flatpakApp" ]]; then
            echo "$flatpakApp is already installed."
        else
            sudo dnf install "$flatpakApp" -y
        fi
    done
elif [[ "$packageManager" = "pacman" ]]; then
    if [[ -f "/usr/bin/notion-app" ]]; then
        echo "Notion is already installed."
    else
        yay -S --noconfirm notion-app-electron
    fi

    if [[ -f "/usr/bin/simplenote" ]]; then
        echo "Simplenote is already installed."
    else
        yay -S --noconfirm simplenote-electron-bin
    fi

    if [[ -f "/usr/bin/todoist" ]]; then
        echo "Todoist is already installed."
    else
        cd ~/AppImages || return
        wget https://todoist.com/linux_app/appimage
        sudo mv appimage /usr/bin/todoist
        cd "$workingDirectory" || return
    fi
else
    echo "Error Message"
fi
