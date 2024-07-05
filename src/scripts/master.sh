#!/bin/bash

# TODO: cd to the root of the project.

workingDirectory=$(pwd)

if [[ -f "/usr/bin/apt-get" ]]; then
    packageManager="apt-get"
elif [[ -f "/usr/bin/dnf" ]]; then
    packageManager="dnf"
fi

# Update the system.
sudo "$packageManager" update -y && sudo "$packageManager" upgrade -y && sudo "$packageManager" autoremove -y

# Organize Directories.
sh "$workingDirectory/src/scripts/organizeHome.sh"

# CLI Tooling.
sh "$workingDirectory/src/scripts/cli.sh"

# Security: YubiKeys, Firewall, VPN, Anti-Virus.
bash "$workingDirectory/src/scripts/security.sh" "$workingDirectory"

# Productivity: Notion, Simplenote, Taskwarrior, Todoist.
bash "$workingDirectory/src/scripts/productivity.sh" "$workingDirectory"

# Web Apps.
bash "$workingDirectory/src/scripts/web.sh"

# Development Setup.
bash "$workingDirectory/src/scripts/dev.sh" "$workingDirectory"

# Shell: Terminator, zsh, oh-my-zsh.
zsh "$workingDirectory/src/scripts/shell.sh" "$workingDirectory"

# Hacking: Burp Suite, Black Arch/Kali tools.
bash "$workingDirectory/src/scripts/hacking.sh" "$workingDirectory"

# Other: Signal, Spotify, Thunderbird.
bash "$workingDirectory/src/scripts/misc.sh"

# Update the system.
if [[ "$packageManager" = "apt-get" || "$packageManager" = "dnf" ]]; then
    sudo "$packageManager" update -y && sudo "$packageManager" upgrade -y && flatpak update -y && sudo "$packageManager" autoremove -y
fi

printf "\n\n============================================================================\n\n"

cat "$workingDirectory/src/assets/wolf.txt"

# Print final output.
printf "\n\n============================================================================\n\n"

printf \
"Run the following to enable Docker daemon on startup:
    sudo systemctl start docker.service
    sudo systemctl enable docker.service
    sudo usermod -aG docker %s
    newgrp docker\r" "$USER"

printf \
"\n\nRun the following to reload oh-my-zsh config:
    omz reload\r"

printf "\n\n============================================================================\n\n\r"

printf "Cheers -- system setup is now complete.\n\r"
