#!/bin/bash

# TODO: cd to the root of the project.

packageManager=""
workingDirectory=$(pwd)

# TODO: Check if apt is binary or alias for apt-get.
if [[ -f "/usr/bin/apt-get" ]]; then
    packageManager="apt"
elif [[ -f "/usr/bin/dnf" ]]; then
    packageManager="dnf"
elif [[ -f "/usr/bin/pacman" ]]; then
    packageManager="pacman"
    if [[ ! -f "/usr/bin/yay" ]]; then
        echo y | sudo pacman -S base-devel
        echo y | sudo pacman -S git

        cd ~/Downloads
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -sri --noconfirm

        cd "$workingDirectory"
    fi
fi

# Exit if package manager is not supported.
if [[ "$packageManager" = "" ]]; then
    echo "The package manager on this system is not supported."
    echo "Currently, these setup scripts support the following package managers:"
    echo "apt, dnf, pacman"
    exit 1
fi

# Update the system.
if [[ "$packageManager" = "pacman" ]]; then
    sudo pacman -Syu --noconfirm && yay -Yc --noconfirm
else
    sudo $packageManager update -y && sudo $packageManager upgrade -y && sudo $packageManager autoremove -y
fi

# Organize Directories.
sh "$workingDirectory/src/scripts/organizeHome.sh"

# Security: YubiKeys, Firewall, VPN, Anti-Virus.
sh "$workingDirectory/src/scripts/security.sh" $packageManager $workingDirectory

# CLI Tooling.
sh "$workingDirectory/src/scripts/cli.sh" $packageManager

# Productivity: Notion, Simplenote, Taskwarrior, Todoist.
sh "$workingDirectory/src/scripts/productivity.sh" $packageManager $workingDirectory

# Web Apps.
sh "$workingDirectory/src/scripts/web.sh" $packageManager

# Development Setup.
sh "$workingDirectory/src/scripts/dev.sh" $packageManager $workingDirectory

# Shell: Terminator, zsh, oh-my-zsh.
zsh "$workingDirectory/src/scripts/shell.sh" $packageManager $workingDirectory

# Other: Thunderbird.
sh "$workingDirectory/src/scripts/misc.sh" $packageManager

# Update the system again.
if [[ "$packageManager" = "pacman" ]]; then
    sudo pacman -Syu --noconfirm && yay -Yc --noconfirm
else
    sudo $packageManager update -y && sudo $packageManager upgrade -y && flatpak update -y && sudo $packageManager autoremove -y
fi

# Print final output.
echo "\n\nCheers -- system setup is now complete!"
