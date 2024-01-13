#!/bin/bash

# TODO: cd to the root of the project.

errorMessage=" is not supported for the $packageManager package manager."
packageManager=""
workingDirectory=$(pwd)

if [[ -f "/usr/bin/apt" ]]; then
    packageManager="apt"
elif [[ -f "/usr/bin/dnf" ]]; then
    packageManager="dnf"
elif [[ -f "/usr/bin/pacman" ]]; then
    packageManager="pacman"
    if [[ ! -f "/usr/bin/yay" ]]; then
        sudo pacman -S --noconfirm base-devel
        sudo pacman -S --noconfirm git

        cd ~/Downloads || return
        git clone https://aur.archlinux.org/yay.git
        cd yay || return
        makepkg -sri --noconfirm

        cd "$workingDirectory" || return
    fi
fi

# Exit if package manager is not supported.
if [[ "$packageManager" = "" ]]; then
    echo "The package manager on this system is not supported."
    echo "The following package managers are supported:"
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
sh "$workingDirectory/src/scripts/security.sh" "$errorMessage" "$packageManager" "$workingDirectory"

# CLI Tooling.
sh "$workingDirectory/src/scripts/cli.sh" $errorMessage $packageManager

# Productivity: Notion, Simplenote, Taskwarrior, Todoist.
sh "$workingDirectory/src/scripts/productivity.sh" $errorMessage $packageManager $workingDirectory

# Web Apps.
sh "$workingDirectory/src/scripts/web.sh" $errorMessage $packageManager

# Development Setup.
sh "$workingDirectory/src/scripts/dev.sh" $errorMessage $packageManager $workingDirectory

# Shell: Terminator, zsh, oh-my-zsh.
zsh "$workingDirectory/src/scripts/shell.sh" $errorMessage $packageManager $workingDirectory

# Hacking: Burp Suite, Black Arch/Kali tools.
sh "$workingDirectory/src/scripts/hacking.sh" $errorMessage $packageManager $workingDirectory

# Other: Thunderbird.
sh "$workingDirectory/src/scripts/misc.sh" $errorMessage $packageManager

# Update the system again.
if [[ "$packageManager" = "apt" || "$packageManager" = "dnf" ]]; then
	sudo $packageManager update -y && sudo $packageManager upgrade -y && flatpak update -y && sudo $packageManager autoremove -y
elif [[ "$packageManager" = "pacman" ]]; then
    sudo pacman -Syu --noconfirm && yay -Yc --noconfirm
else
    echo "Error Message"
fi

# Print final output.
printf "\n\n\nCheers -- system setup is now complete!\n"
