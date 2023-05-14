#!/bin/bash

# Add non-automated tasks to Taskwarrior
if [[ -f "/usr/local/cellar/task/" ]]; then
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
else
	echo "Taskwarrior is not installed. Please install Taskwarrior and re-run the addTasks script."
fi
