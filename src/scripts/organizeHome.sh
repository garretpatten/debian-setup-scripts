#!/bin/bash

# Remove unneeded directories
directoriesToRemove=("Desktop" "Music" "Public" "Templates" "Videos")
for directoryToRemove in ${directoriesToRemove[@]}; do
	if [[ -d "$HOME/$directoryToRemove/" ]]; then
		rmdir "$HOME/$directoryToRemove"
	else
		echo "$HOME/$directoryToRemove is already removed."
	fi
done

# Add needed directories
# TODO: Add directories that align with backups
directoriesToCreate=("AppImages" "Repos")
for directoryToCreate in ${directoriesToCreate[@]}; do
	if [[ -d "$HOME/$directoryToCreate/" ]]; then
		echo "$HOME/$directoryToCreate is already created."
	else
		mkdir "$HOME/$directoryToCreate"
	fi
done
