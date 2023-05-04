# Thunderbird
if [[ -f "/usr/bin/thunderbird" ]]; then
 	echo "Thunderbird is already installed."
 else
	sudo dnf install thunderbird -y
fi

# VLC
# TODO: Below line is failing to parse
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y
sudo dnf install vlc -y
