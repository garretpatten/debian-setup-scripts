#!/bin/bash

# shellcheck source=../utils.sh
source "$(dirname "$0")/../utils.sh"

update_apt_cache

libreoffice_packages=(
    "libreoffice"
    "libreoffice-gtk3"
    "libreoffice-style-breeze"
)
install_apt_packages "${libreoffice_packages[@]}"

zoom_deb="$TEMP_DIR/zoom_amd64.deb"
if ! command -v zoom >/dev/null 2>&1; then
    if download_file_safe "https://zoom.us/client/latest/zoom_amd64.deb" "$zoom_deb"; then
        sudo dpkg -i "$zoom_deb" 2>>"$ERROR_LOG_FILE" || true
        sudo apt-get install -f -y 2>>"$ERROR_LOG_FILE" || true
    fi
fi

if flatpak remote-info flathub >/dev/null 2>&1; then
    flatpak install -y flathub org.standardnotes.standardnotes 2>>"$ERROR_LOG_FILE" || true
fi

productivity_packages=(
    "keepassxc"
    "redshift"
    "flameshot"
)
install_apt_packages "${productivity_packages[@]}"

etcher_dir="$HOME/.local/bin"
etcher_path="$etcher_dir/balenaEtcher.AppImage"
if [[ ! -f "$etcher_path" ]]; then
    ensure_directory "$etcher_dir"
    install_apt_packages "libfuse2"
    etcher_url=$(curl -s https://api.github.com/repos/balena-io/etcher/releases/latest 2>>"$ERROR_LOG_FILE" | grep "browser_download_url.*x64.AppImage" | head -1 | cut -d '"' -f 4)
    if [[ -n "$etcher_url" ]]; then
        download_file_safe "$etcher_url" "$etcher_path"
        if [[ -f "$etcher_path" ]] && [[ -s "$etcher_path" ]]; then
            chmod +x "$etcher_path" 2>>"$ERROR_LOG_FILE" || true
        fi
    fi
fi
