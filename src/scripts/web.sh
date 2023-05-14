# Install Brave
if [[ -f "/usr/bin/brave-browser" ]]; then
    echo "Braver browser is already installed."
else
    sudo dnf install dnf-plugins-core -y
    sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
    sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
    sudo dnf install brave-browser -y
fi
