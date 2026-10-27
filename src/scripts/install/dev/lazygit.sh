#!/bin/bash
# Lazygit binary install for Debian releases where the apt package is unavailable.

command -v lazygit >/dev/null 2>&1 && exit 0

LAZYGIT_VERSION="0.66.2"

arch="$(uname -m)"
case "$arch" in
    x86_64)
        target="x86_64"
        ;;
    aarch64 | arm64)
        target="arm64"
        ;;
    *)
        echo "Unsupported architecture for lazygit binary install: $arch" >&2
        exit 0
        ;;
esac

tarball="lazygit_${LAZYGIT_VERSION}_linux_${target}.tar.gz"
url="https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/${tarball}"
download_path="${TEMP_DIR:-/tmp}/${tarball}"

curl -fsSL --connect-timeout 30 --max-time 300 --retry 3 --retry-delay 2 "$url" -o "$download_path" || exit 0

if [[ ! -f "$download_path" ]] || [[ ! -s "$download_path" ]]; then
    exit 0
fi

extract_dir="${TEMP_DIR:-/tmp}/lazygit-extract"
rm -rf "$extract_dir"
mkdir -p "$extract_dir"
tar -xzf "$download_path" -C "$extract_dir" 2>/dev/null || exit 0

if [[ -x "$extract_dir/lazygit" ]]; then
    sudo install -m 755 "$extract_dir/lazygit" /usr/local/bin/lazygit || true
fi
