# Install Flatpak
if [[ -f "/usr/bin/flatpak" ]]; then
	echo "flatpak is already installed."
else
	sudo dnf install flatpak -y
fi

# Add remote Flatpak repos
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# TODO: Add FlatHub remote

# Install Signal Messenger, Simplenote, Spotify
flatpakApps=("org.signal.Signal" "com.spotify.Client")
for flatpakApp in ${flatpakApps[@]}; do
	if [[ -d "/var/lib/flatpak/app/$flatpakApp" ]]; then
		echo "$flatpak is already installed."
	elif [[ -d "~/.local/share/flatpak/app/$flatpakApp"]]; then
		echo "$flatpak is already installed."
	else
		flatpak install flathub "$flatpak" -y
	fi
done
