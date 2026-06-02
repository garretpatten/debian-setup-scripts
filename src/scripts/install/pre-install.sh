#!/bin/bash

# shellcheck source-path=SCRIPTDIR
# shellcheck source=../utils.sh
# shellcheck disable=SC1091
source "$(dirname "$0")/../utils.sh"

update_apt_cache

enable_debian_contrib_nonfree

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
