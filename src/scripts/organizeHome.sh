#!/bin/bash

# Remove unneeded directories.
directoriesToRemove=("Music" "Public" "Templates" "Videos")
for directoryToRemove in ${directoriesToRemove[@]}; do
	if [[ -d "$HOME/$directoryToRemove/" ]]; then
		rmdir "$HOME/$directoryToRemove"
	else
		echo "$HOME/$directoryToRemove is already removed."
	fi
done

# Add needed directories.
directoriesToCreate=("AppImages" "Repos" "Writing")
for directoryToCreate in ${directoriesToCreate[@]}; do
	if [[ -d "$HOME/$directoryToCreate/" ]]; then
		echo "$HOME/$directoryToCreate is already created."
	else
		mkdir "$HOME/$directoryToCreate"
	fi
done
