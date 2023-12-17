#!/bin/bash

packageManager=$1

# Taskwarrior
if [[ -f "/usr/bin/task" ]]; then
	echo "Taskwarrior is already installed."
else
	task="task"
	if [[ "$packageManager" = "pacman" ]]; then
		echo y | sudo pacman -S "$task"
	else
		# TODO: Check if apt uses "taskwarrior"
		sudo $packageManager install "$task" -y
	fi

	# TODO: Handle first Taskwarrior prompt

	# Add Manual Setup Tasks
	task add Install Timeshift project:setup priority:H
	task add Take a snapshot of system project:setup priority:H
	task add Update .zshrc project:dev priority:H

	task add Sign into and sync Brave project:setup priority:M
	task add Configure 1Password project:setup priority:M

	task add Install Burp Suite project:setup priority:L
	task add Download needed files from Proton Drive project:setup priority:L
fi

# Taskwarrior Config
cat "$(pwd)/src/config-files/taskwarrior/taskrcUpdates.txt" >> ~/.taskrc

# Add Custom Themes Directory
if [[ -d "$HOME/.task/themes/" ]]; then
	echo "Taskwarrior themes directory already exists."
else
	mkdir ~/.task/themes/
fi

# TODO: Update this from copying an artifact to pulling themes from GitHub
# Add Custom Themes
cp -r "$(pwd)/src/config-files/taskwarrior/themes/" ~/.task/themes/

# Notion, Simplenote, and Todoist
if [[ "$packageManager" = "pacman" ]]; then
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
		currentPath=$(pwd)
		cd ~/AppImages
		wget https://todoist.com/linux_app/appimage
		sudo mv appimage /usr/bin/todoist
	fi
else
	if [[ "$packageManager" = "apt" ]]; then
		echo "deb [trusted=yes] https://apt.fury.io/notion-repackaged/ /" | sudo tee /etc/apt/sources.list.d/notion-repackaged.list
		sudo apt update -y
		sudo apt install notion-app-enhanced -y
		sudo apt install notion-app
	elif [[ "$packageManager" = "apt" ]]; then
		# TODO: Install Notion on dnf
		"Support not yet added for dnf."
	else
		echo "Support not yet added for this package manager."
	fi

	flatpakApps=("com.simplenote.Simplenote" "com.todoist.Todoist")
	for flatpakApp in ${flatpakApps[@]}; do
		if [[ -d "/var/lib/flatpak/app/$flatpakApp" ]]; then
			echo "$flatpak is already installed."
		elif [[ -d "$HOME/.local/share/flatpak/app/$flatpakApp" ]]; then
			echo "$flatpak is already installed."
		else
			sudo dnf install "$flatpakApp" -y
		fi
	done
fi
