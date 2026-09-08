#!/bin/bash
# eza binary install fallback for Debian releases where the apt package is unavailable.

command -v eza >/dev/null 2>&1 && exit 0

EZA_VERSION="0.20.9"

arch="$(uname -m)"
case "$arch" in
    x86_64)
        target="x86_64-unknown-linux-gnu"
        ;;
    aarch64 | arm64)
        target="aarch64-unknown-linux-gnu"
        ;;
    *)
        echo "Unsupported architecture for eza binary install: $arch" >&2
        exit 0
        ;;
esac

tarball="eza_${target}.tar.gz"
url="https://github.com/eza-community/eza/releases/download/v${EZA_VERSION}/${tarball}"
download_path="${TEMP_DIR:-/tmp}/${tarball}"

curl -fsSL --connect-timeout 30 --max-time 300 --retry 3 --retry-delay 2 "$url" -o "$download_path" || exit 0

if [[ ! -f "$download_path" ]] || [[ ! -s "$download_path" ]]; then
    exit 0
fi

extract_dir="${TEMP_DIR:-/tmp}/eza-extract"
mkdir -p "$extract_dir"
tar -xzf "$download_path" -C "$extract_dir" 2>/dev/null || exit 0

if [[ -x "$extract_dir/eza" ]]; then
    sudo install -m 755 "$extract_dir/eza" /usr/local/bin/eza || true
fi
