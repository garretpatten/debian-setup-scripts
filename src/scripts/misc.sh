# Thunderbird
if [[ -f "/usr/bin/thunderbird" ]]; then
 	echo "Thunderbird is already installed."
 else
	echo y | yay -S thunderbird
fi

# VLC
echo y | yay -S vlc
