#!/bin/bash
# Ghostty terminal from the community .deb packages linked by ghostty.org
# (https://ghostty.org/docs/install/binary); the Ghostty project does not
# distribute official Linux binaries.

command -v ghostty >/dev/null 2>&1 && exit 0

arch="$(uname -m)"
case "$arch" in
    x86_64)
        deb_arch="amd64"
        ;;
    aarch64 | arm64)
        deb_arch="arm64"
        ;;
    *)
        echo "Unsupported architecture for ghostty install: $arch" >&2
        exit 0
        ;;
esac

codename="$(lsb_release -sc 2>/dev/null || echo "")"
case "$codename" in
    # Ghostty 1.2+ requires GTK 4.14 / libadwaita 1.5, which bookworm lacks;
    # 1.1.x is the last series compatible with bookworm's GTK 4.8.
    bookworm)
        ghostty_deb="https://github.com/mkasberg/ghostty-ubuntu/releases/download/1.1.3-0-ppa2/ghostty_1.1.3-0.ppa2_${deb_arch}_bookworm.deb"
        ;;
    trixie)
        ghostty_deb="https://github.com/mkasberg/ghostty-ubuntu/releases/download/1.3.1-0-ppa2/ghostty_1.3.1-0.ppa2_${deb_arch}_trixie.deb"
        ;;
    forky)
        ghostty_deb="https://github.com/mkasberg/ghostty-ubuntu/releases/download/1.3.1-0-ppa2/ghostty_1.3.1-0.ppa2_${deb_arch}_forky.deb"
        ;;
    *)
        echo "No community ghostty .deb available for codename: $codename" >&2
        exit 0
        ;;
esac

ghostty_pkg="${TEMP_DIR:-/tmp}/ghostty-${deb_arch}-${codename}.deb"
curl -fsSL --connect-timeout 30 --max-time 300 --retry 3 --retry-delay 2 "$ghostty_deb" -o "$ghostty_pkg" || exit 0

if [[ ! -s "$ghostty_pkg" ]]; then
    exit 0
fi

sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends "$ghostty_pkg" || true
