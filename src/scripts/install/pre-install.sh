#!/bin/bash

# shellcheck source=../utils.sh
source "$(dirname "$0")/../utils.sh"

update_apt_cache

if [[ -f /etc/apt/sources.list ]] && ! grep -qE '\bcontrib\b' /etc/apt/sources.list 2>/dev/null; then
    sudo sed -E -i 's/([[:space:]]main)([[:space:]]*$)/\1 contrib non-free non-free-firmware\2/' /etc/apt/sources.list 2>>"$ERROR_LOG_FILE" || true
    update_apt_cache
fi

sudo apt-get upgrade -y 2>>"$ERROR_LOG_FILE" || true
sudo apt-get autoremove -y 2>>"$ERROR_LOG_FILE" || true
sudo apt-get autoclean 2>>"$ERROR_LOG_FILE" || true

essential_tools=(
    "git"
    "curl"
    "wget"
    "apt-transport-https"
    "ca-certificates"
    "gnupg"
    "lsb-release"
)
install_apt_packages "${essential_tools[@]}"

if [[ "$(timedatectl show --property=Timezone --value)" == "UTC" ]]; then
    sudo timedatectl set-timezone America/New_York 2>>"$ERROR_LOG_FILE" || true
fi
