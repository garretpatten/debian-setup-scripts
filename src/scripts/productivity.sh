# Install taskwarrior
if [[ -f "/usr/bin/task" ]]; then
	echo "Taskwarrior is already installed."
else
	echo y | yay -S task
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

# Install Simplenote and Todoist
if [[ -f "/usr/bin/simplenote" ]]; then
	echo "Simplenote is already installed."
else
	yay -S simplenote-electron-bin
	# TODO: Automate 2 Enter keypresses and Y parameter
fi
if [[ -f "/usr/bin/todoist" ]]; then
	echo "Todoist is already installed."
else
	# TODO: Install Todoist via AppImage (https://todoist.com/help/articles/how-to-install-todoist-on-linux#install-todoist-using-appimage)
fi



apps=("simplenote-electron-bin" "todoist")
for app in ${apps[@]}; do
	if [[ -d "/usr/bin/$app" ]]; then
		echo "$app is already installed."
	elif [[ -d "~/.local/share/flatpak/app/$app" ]]; then
		echo "$app is already installed."
	else
		yay -S "$app"
	fi
done
