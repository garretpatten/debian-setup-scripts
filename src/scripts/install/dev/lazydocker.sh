#!/bin/bash
# Lazydocker binary install for Debian releases where the apt package is unavailable.

command -v lazydocker >/dev/null 2>&1 && exit 0

LAZYDOCKER_VERSION="0.25.2"

arch="$(uname -m)"
case "$arch" in
    x86_64)
        target="x86_64"
        ;;
    aarch64 | arm64)
        target="arm64"
        ;;
    *)
        echo "Unsupported architecture for lazydocker binary install: $arch" >&2
        exit 0
        ;;
esac

tarball="lazydocker_${LAZYDOCKER_VERSION}_Linux_${target}.tar.gz"
url="https://github.com/jesseduffield/lazydocker/releases/download/v${LAZYDOCKER_VERSION}/${tarball}"
download_path="${TEMP_DIR:-/tmp}/${tarball}"

curl -fsSL --connect-timeout 30 --max-time 300 --retry 3 --retry-delay 2 "$url" -o "$download_path" || exit 0

if [[ ! -f "$download_path" ]] || [[ ! -s "$download_path" ]]; then
    exit 0
fi

extract_dir="${TEMP_DIR:-/tmp}/lazydocker-extract"
rm -rf "$extract_dir"
mkdir -p "$extract_dir"
tar -xzf "$download_path" -C "$extract_dir" 2>/dev/null || exit 0

if [[ -x "$extract_dir/lazydocker" ]]; then
    sudo install -m 755 "$extract_dir/lazydocker" /usr/local/bin/lazydocker || true
fi
