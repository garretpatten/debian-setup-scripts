# Install basic CLI tools
cliTools=("bat" "curl" "exa" "git" "https" "htop" "neofetch" "openvpn" "python3" "wget")
for cliTool in ${cliTools[@]}; do
	if [[ -d "/usr/bin/$cliTool/" ]]; then
		echo "$cliTool is already installed."
	elif [[ -f "/usr/sbin/$cliTool" ]]; then
		echo "$cliTool is already installed."
	else
		echo y | yay -S "$cliTool"
	fi
done
