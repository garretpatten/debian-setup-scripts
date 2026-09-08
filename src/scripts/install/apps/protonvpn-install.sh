#!/bin/bash
# Proton VPN GNOME desktop app from the official Debian repository.

protonvpn_deb="${TEMP_DIR:-/tmp}/protonvpn-stable-release.deb"
protonvpn_release_url="https://repo.protonvpn.com/debian/dists/stable/main/binary-all/protonvpn-stable-release_1.0.8_all.deb"
protonvpn_sha256="0b14e71586b22e498eb20926c48c7b434b751149b1f2af9902ef1cfe6b03e180"

if dpkg -s proton-vpn-gnome-desktop >/dev/null 2>&1; then
    exit 0
fi

if [[ ! -f "$protonvpn_deb" ]]; then
    curl -fsSL --retry 3 --retry-delay 2 "$protonvpn_release_url" -o "$protonvpn_deb" || true
fi

if [[ ! -f "$protonvpn_deb" ]]; then
    exit 0
fi

if ! printf '%s  %s\n' "$protonvpn_sha256" "$protonvpn_deb" | sha256sum -c - >/dev/null 2>&1; then
    exit 0
fi

sudo dpkg -i "$protonvpn_deb" || true
sudo DEBIAN_FRONTEND=noninteractive apt-get install -f -y --no-install-recommends || true
sudo apt-get update -y || true

# Reconcile any half-configured state left by dpkg before installing the desktop package.
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends proton-vpn-gnome-desktop || true
