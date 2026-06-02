#!/bin/bash

# shellcheck source=../utils.sh
source "$(dirname "$0")/../utils.sh"

update_apt_cache

install_apt_packages "flatpak"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo 2>/dev/null || true

cli_tools=(
    "bat"
    "curl"
    "eza"
    "fd-find"
    "git"
    "htop"
    "jq"
    "ripgrep"
    "vim"
    "wget"
)
install_apt_packages "${cli_tools[@]}"

install_apt_packages "btop"

debian_codename="$(lsb_release -sc 2>/dev/null || echo "")"
if [[ -n "$debian_codename" ]] && ! apt-cache show fastfetch >/dev/null 2>&1; then
    backports_list="/etc/apt/sources.list.d/${debian_codename}-backports.list"
    if [[ ! -f "$backports_list" ]]; then
        echo "deb http://deb.debian.org/debian ${debian_codename}-backports main contrib non-free non-free-firmware" 2>>"$ERROR_LOG_FILE" | \
            sudo tee "$backports_list" > /dev/null 2>>"$ERROR_LOG_FILE" || true
        update_apt_cache
    fi
fi

if apt-cache show fastfetch >/dev/null 2>&1; then
    install_apt_packages "fastfetch"
elif [[ -n "$debian_codename" ]] && apt-cache show -t "${debian_codename}-backports" fastfetch >/dev/null 2>&1; then
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -t "${debian_codename}-backports" fastfetch 2>>"$ERROR_LOG_FILE" || \
        log_error "Failed to install fastfetch from backports"
else
    log_error "fastfetch not available via APT on this Debian release"
fi
