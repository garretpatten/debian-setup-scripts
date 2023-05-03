#!/bin/bash

# Checkout home directory
cd

# Remove unneeded directories
directoriesToRemove=("Desktop" "Music" "Public" "Templates" "Videos")
for directoryToRemove in ${directoriesToRemove[@]}; do
	if [[ -d "~/$directoryToRemove/" ]]; then
		rmdir "$directoryToRemove"
	else
		echo "$directoryToRemove is already removed."
	fi
done

# Add needed directories
# TODO: Add directories that align with backups
directoriesToCreate=("repos")
for directoryToCreate in ${directoriesToCreate[@]}; do
	if [[ -d "~/$directoryToCreate/" ]]; then
		echo "$directoryToCreate is already created."
	else
		mkdir "$directoryToCreate"
	fi
done
