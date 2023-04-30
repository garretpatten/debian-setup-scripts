# Install Flatpak
sudo dnf install flatpak -y

# Add remote Flatpak repos
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# TODO: Add FlatHub remote

# Install Signal Messenger
flatpak install flathub org.signal.Signal -y

# Install Simplenote
flatpak install flathub com.simplenote.Simplenote -y

# Install Spotify
flatpak install flathub com.spotify.client -y
