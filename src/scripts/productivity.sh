# Install taskwarrior
sudo dnf install task -y

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
cp "$(pwd)/src/artifacts/taskwarrior/themes/" ~/.task/themes/

# TODO: Set dark blue theme

# Install Simplenote and Todoist
flatpakApps=("com.simplenote.Simplenote" "com.todoist.Todoist")
for flatpakApp in ${flatpakApps[@]}; do
	# TODO: Path to flatpak apps is either /var/lib/flatpak or ~/.local/share/flatpak
	if [[ -d "path/to/$flatpakApp" ]]; then
		echo "$flatpakApp is already installed."
	else
		brew install --cask "$flatpakApp"
	fi
done
