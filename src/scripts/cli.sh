# Install basic CLI tools
cliTools=("bat" "curl" "exa" "git" "https" "htop" "neofetch" "openvpn" "wget")
for tool in ${cliTools[@]}; do
	if [[ -d "/usr/local/bin/$tool/" ]]; then
			echo "$tool is already installed."
	else
		sudo dnf install "$tool" -y
	fi
done
