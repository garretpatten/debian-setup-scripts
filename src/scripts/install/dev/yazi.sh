#!/bin/bash
# Yazi file manager binary install for Debian releases where the apt package is unavailable.
# Uses the static musl build; the gnu build requires a newer glibc than bookworm ships.

command -v yazi >/dev/null 2>&1 && exit 0

arch="$(uname -m)"
case "$arch" in
    x86_64)
        target="x86_64-unknown-linux-musl"
        ;;
    aarch64 | arm64)
        target="aarch64-unknown-linux-musl"
        ;;
    *)
        echo "Unsupported architecture for yazi binary install: $arch" >&2
        exit 0
        ;;
esac

zip_file="yazi-${target}.zip"
url="https://github.com/sxyazi/yazi/releases/latest/download/${zip_file}"
download_path="${TEMP_DIR:-/tmp}/${zip_file}"

curl -fsSL --connect-timeout 30 --max-time 300 --retry 3 --retry-delay 2 "$url" -o "$download_path" || exit 0

if [[ ! -f "$download_path" ]] || [[ ! -s "$download_path" ]]; then
    exit 0
fi

extract_dir="${TEMP_DIR:-/tmp}/yazi-extract"
rm -rf "$extract_dir"
mkdir -p "$extract_dir"
unzip -q "$download_path" -d "$extract_dir" 2>/dev/null || exit 0

if [[ -x "$extract_dir/yazi-${target}/yazi" ]]; then
    sudo install -m 755 "$extract_dir/yazi-${target}/yazi" /usr/local/bin/yazi || true
fi

if [[ -x "$extract_dir/yazi-${target}/ya" ]]; then
    sudo install -m 755 "$extract_dir/yazi-${target}/ya" /usr/local/bin/ya || true
fi
