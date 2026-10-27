#!/bin/bash
# Fastfetch binary install for Debian releases where the apt package is unavailable.

command -v fastfetch >/dev/null 2>&1 && exit 0

arch="$(uname -m)"
case "$arch" in
    x86_64)
        target="amd64"
        ;;
    aarch64 | arm64)
        target="aarch64"
        ;;
    *)
        echo "Unsupported architecture for fastfetch binary install: $arch" >&2
        exit 0
        ;;
esac

tarball="fastfetch-linux-${target}.tar.gz"
url="https://github.com/fastfetch-cli/fastfetch/releases/latest/download/${tarball}"
download_path="${TEMP_DIR:-/tmp}/${tarball}"

curl -fsSL --connect-timeout 30 --max-time 300 --retry 3 --retry-delay 2 "$url" -o "$download_path" || exit 0

if [[ ! -f "$download_path" ]] || [[ ! -s "$download_path" ]]; then
    exit 0
fi

extract_dir="${TEMP_DIR:-/tmp}/fastfetch-extract"
rm -rf "$extract_dir"
mkdir -p "$extract_dir"
tar -xzf "$download_path" -C "$extract_dir" 2>/dev/null || exit 0

if [[ -x "$extract_dir/fastfetch-linux-${target}/usr/bin/fastfetch" ]]; then
    sudo install -m 755 "$extract_dir/fastfetch-linux-${target}/usr/bin/fastfetch" /usr/local/bin/fastfetch || true
fi
