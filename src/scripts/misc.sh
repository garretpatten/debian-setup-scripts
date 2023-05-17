# Thunderbird
if [[ -f "/usr/bin/thunderbird" ]]; then
 	echo "Thunderbird is already installed."
 else
	yay -S thunderbird
fi

# VLC
# TODO: Below line is failing to parse
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y
yay -S vlc
