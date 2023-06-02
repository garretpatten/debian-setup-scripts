#!/bin/bash

packageManager=""

if [[ -f "/usr/bin/dnf" ]]; then
    packageManager="dnf"
elif [[ -f "/usr/bin/pacman" ]]; then
    packageManager="pacman"
    if [[ ! -f "/usr/bin/yay" ]]; then
        echo y | sudo pacman -S base-devel
        echo y | sudo pacman -S git

        currentPath=$(pwd)
        cd ~/Downloads
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si

        cd $currentPath
    fi
# TODO: Check if apt is binary or alias for apt-get
elif [[ -f "/usr/bin/apt-get" ]]; then
    packageManager="apt"
else
    echo "The package manager on this system is not supported."
    echo "Currently, these setup scripts support the following package managers:"
    echo "apt, dnf, pacman"
    exit 1
fi

# Begin: System Updates
if [[ "$packageManager" = "pacman" ]]; then
    sudo pacman -Syu && yay -Yc
else
    sudo $packageManager upgrade -y && sudo $packageManager update -y && sudo $packageManager autoremove -y
fi

# TODO: cd to the root of the project

# Organize Directories
sh "$(pwd)/src/scripts/organizeHome.sh"

# Security: YubiKeys, Firewall, VPN, Anti-Virus
sh "$(pwd)/src/scripts/security.sh" $packageManager

# CLI Tooling
sh "$(pwd)/src/scripts/cli.sh" $packageManager

# Productivity: Taskwarrior, Todoist
sh "$(pwd)/src/scripts/productivity.sh" $packageManager

# Web Apps
sh "$(pwd)/src/scripts/web.sh" $packageManager

# Development Setup
sh "$(pwd)/src/scripts/dev.sh" $packageManager

# Shell: Terminator, zsh, oh-my-zsh
zsh "$(pwd)/src/scripts/shell.sh" $packageManager

# Other: Thunderbird
sh "$(pwd)/src/scripts/misc.sh" $packageManager

# End: System Updates
if [[ "$packageManager" = "pacman" ]]; then
    sudo pacman -Syu && yay -Yc
else
    sudo $packageManager upgrade -y && sudo $packageManager update -y && flatpak update -y && sudo $packageManager autoremove -y
fi

# Create a break in output
echo ""
echo ""

echo "Cheers -- system setup is now complete!"
