# Install taskwarrior
if [[ -f "/usr/bin/task" ]]; then
	echo "Taskwarrior is already installed."
else
	echo y | sudo pacman -S task

	# TODO: Handle first Taskwarrior prompt
	#
	# Add non-automated setup tasks
	# High Priority Tasks
	task add Install Timeshift project:setup priority:H
	task add Take a snapshot of system project:setup priority:H
	task add Export GitHub PAT with 1Password project:dev priority:H

	# Medium Priority Tasks
	task add Sign into and sync Brave project:setup priority:M
	task add Sign into Firefox project:setup priority:M
	task add Look into Gnome tweaks project:setup priority:M

	# Low Priority Tasks
	task add Install Burp Suite project:setup priority:L
	task add Download files from Proton Drive project:setup priority:L
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
	currentPath=$(pwd)
	cd ~/AppImages
	wget https://todoist.com/linux_app/appimage
	sudo mv appimage /usr/bin/todoist
	cd $currentPath
fi
