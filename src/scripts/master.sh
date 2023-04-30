# Begin: System Updates
sudo dnf upgrade -y && sudo dnf update-y && sudo dnf autoremove

sudo chmod +x ./

# Security: YubiKeys, Firewall, VPN, Anti-Virus
sh ./security.sh

# CLI Tooling
sh ./cli.sh

# Flatpak Apps
sh ./flatpak.sh

# Shell: Terminator, zsh, oh-my-zsh
sh ./shell.sh

# Productivity: Taskwarrior, Todoist
sh ./productivity.sh

# Web Apps
sh ./web.sh

# Development Setup
sh ./dev.sh

# Other
sh ./misc.sh

# Add Taskwarrior tasks
sh ./addTasks.sh

# End: System Updates
sudo dnf upgrade-y && sudo dnf update-y && sudo dnf autoremove

# Create a break in output
echo ''
echo ''
echo ''

echo "Cheers -- system setup is now complete!"
