#!/bin/bash

if [[ -f "usr/bin/dnf" ]]; then
    packageManager="dnf"
else if [[ -f "usr/bin/pacman" ]]; then
    packageManager="pacman"
    if ! [[ -f "/usr/bin/yay" ]]; then
        # TODO: Install yay
    fi
# TODO: Check if apt is binary or alias for apt-get
else if [[ -f "/usr/bin/apt-get" ]]; then
    packageManager="apt"
else if [[ -f "/usr/bin/deb" ]]; then
    packageManager="deb"
else
    echo "The package manager on this system is not supported."
    echo "Currently, these setup scripts support the following package managers:"
    echo "apt, deb, dnf, pacman"
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
sh "$(pwd)/src/scripts/security.sh"

# CLI Tooling
sh "$(pwd)/src/scripts/cli.sh"

# Flatpak Apps
sh "$(pwd)/src/scripts/flatpak.sh"

# Productivity: Taskwarrior, Todoist
sh "$(pwd)/src/scripts/productivity.sh"

# Web Apps
sh "$(pwd)/src/scripts/web.sh"

# Development Setup
sh "$(pwd)/src/scripts/dev.sh"

# Shell: Terminator, zsh, oh-my-zsh
sh "$(pwd)/src/scripts/shell.sh"

# Other: Thunderbird
sh "$(pwd)/src/scripts/misc.sh"

# Add Taskwarrior tasks
sh "$(pwd)/src/scripts/addTasks.sh"

# End: System Updates
if [[ "$packageManager" = "pacman" ]]; then
    sudo pacman -Syu && yay -Yc
else
    sudo $packageManager upgrade -y && sudo $packageManager update -y && flatpak update -y && sudo $packageManager autoremove -y
fi

# Create a break in output
echo ''
echo ''
echo ''

echo "Cheers -- system setup is now complete!"
