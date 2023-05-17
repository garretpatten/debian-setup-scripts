# Install taskwarrior
if [[ -f "/usr/bin/task" ]]; then
	echo "Taskwarrior is already installed."
else
	yay -S task
fi

# Taskwarrior config
cat "$(pwd)/src/artifacts/taskwarrior/taskrcUpdates.txt" >> ~/.taskrc

# Add directory for custom themes
if [[ -d "~/.task/themes/" ]]; then
	echo "Taskwarrior themes directory already exists."
else
	mkdir ~/.task/themes/
fi

### TODO: Update this from copying an artifact to pulling themes from GitHub ###
# Add custom themes to directory
cp -r "$(pwd)/src/artifacts/taskwarrior/themes/" ~/.task/themes/

# TODO: Set dark blue theme

# # Install Simplenote and Todoist
# flatpakApps=("com.simplenote.Simplenote" "com.todoist.Todoist")
# for flatpakApp in ${flatpakApps[@]}; do
# 	if [[ -d "/var/lib/flatpak/app/$flatpakApp" ]]; then
# 		echo "$flatpak is already installed."
# 	elif [[ -d "~/.local/share/flatpak/app/$flatpakApp" ]]; then
# 		echo "$flatpak is already installed."
# 	else
# 		sudo dnf install "$flatpakApp" -y
# 	fi
# done
