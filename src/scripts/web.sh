# Install Brave
if [[ -f "/usr/bin/brave-browser" ]]; then
    echo "Braver browser is already installed."
else
    yay -S brave-bin
    # TODO: Automate 2 Enter keypresses and Y parameter
fi
