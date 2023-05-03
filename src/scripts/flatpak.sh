# Install Flatpak
if [[ -f "/usr/local/bin/flatpak" ]]; then
	echo "flatpak is already installed."
else
	sudo dnf install flatpak -y
fi

# Add remote Flatpak repos
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# TODO: Add FlatHub remote

# Install Signal Messenger, Simplenote, Spotify
flatpakApps=("org.signal.Signal" "com.simplenote.Simplenote" "com.spotify.Client")
for flatpakApp in ${flatpakApps[@]}; do
	# TODO: Path to flatpak apps is either /var/lib/flatpak or ~/.local/share/flatpak
	if [[ -d "path/to/$flatpakApp" ]]; then
		echo "$flatpak is already installed."
	else
		flatpak install flathub "$flatpak" -y
	fi
done
