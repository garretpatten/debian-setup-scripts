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

desktop_packages=(
    "gnome-shell-extensions"
    "gnome-tweaks"
)
install_apt_packages "${desktop_packages[@]}"

bruno_keyring="/etc/apt/keyrings/bruno.gpg"
if [[ ! -f "$bruno_keyring" ]]; then
    curl -fsSL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x9FA6017ECABE0266" 2>>"$ERROR_LOG_FILE" | \
        sudo gpg --dearmor -o "$bruno_keyring" 2>>"$ERROR_LOG_FILE" || true
    sudo chmod 644 "$bruno_keyring" 2>>"$ERROR_LOG_FILE" || true
fi

if [[ ! -f "/etc/apt/sources.list.d/bruno.list" ]] || ! grep -q "debian.usebruno.com" "/etc/apt/sources.list.d/bruno.list" 2>/dev/null; then
    echo "deb [arch=amd64 signed-by=${bruno_keyring}] http://debian.usebruno.com/ bruno stable" 2>>"$ERROR_LOG_FILE" | \
        sudo tee /etc/apt/sources.list.d/bruno.list > /dev/null 2>>"$ERROR_LOG_FILE" || true
    update_apt_cache
fi

install_apt_packages "bruno"

zoom_deb="$TEMP_DIR/zoom_amd64.deb"
if ! command -v zoom >/dev/null 2>&1; then
    if download_file_safe "https://zoom.us/client/latest/zoom_amd64.deb" "$zoom_deb"; then
        sudo dpkg -i "$zoom_deb" 2>>"$ERROR_LOG_FILE" || true
        sudo apt-get install -f -y 2>>"$ERROR_LOG_FILE" || true
    fi
fi

productivity_packages=(
    "keepassxc"
    "redshift"
    "flameshot"
)
install_apt_packages "${productivity_packages[@]}"

if ! command -v google-chrome >/dev/null 2>&1 && ! dpkg -s google-chrome-stable >/dev/null 2>&1; then
    chrome_deb="$TEMP_DIR/google-chrome-stable.deb"
    if download_file_safe "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" "$chrome_deb"; then
        sudo dpkg -i "$chrome_deb" 2>>"$ERROR_LOG_FILE" || true
        sudo apt-get install -f -y 2>>"$ERROR_LOG_FILE" || true
    fi
fi

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
