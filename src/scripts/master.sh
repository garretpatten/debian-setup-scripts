# Begin: System Updates
sudo dnf upgrade -y && sudo dnf update-y && sudo dnf autoremove

# Security: YubiKeys, Firewall, VPN, Anti-Virus
sh ./security.sh

# CLI Tooling
sh ./cli.sh

# Flatpak Setup
sh ./flatpak.sh

# Shell: Terminator, zsh, oh-my-zsh
sh ./shell.sh

# Productivity: Taskwarrior, Todoist
sh ./productivity.sh

# Web Apps
sh ./web.sh

# Development Setup
sh ./dev.sh

# Add Taskwarrior tasks
sh ./addTasks.sh

# End: System Updates
sudo dnf upgrade-y && sudo dnf update-y && sudo dnf autoremove

# Create a break in output
echo ''
echo ''
echo ''

echo "Cheers -- system setup is now complete!"
