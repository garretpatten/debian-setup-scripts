# Thunderbird
sudo dnf install thunderbird -y

# VLC
sudo dnf install https -y
# TODO: Below line is failing to parse
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y
sudo dnf install vlc -y