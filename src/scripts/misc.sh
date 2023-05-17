# Thunderbird
if [[ -f "/usr/bin/thunderbird" ]]; then
 	echo "Thunderbird is already installed."
 else
	echo y | yay -S thunderbird
fi

# VLC
# TODO: Below line is failing to parse
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y
echo y | yay -S vlc
