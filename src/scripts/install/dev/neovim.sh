#!/bin/bash
# Neovim from official GitHub releases (the Debian archive package trails far behind).

command -v nvim >/dev/null 2>&1 && exit 0

NVIM_VERSION="0.12.6"

arch="$(uname -m)"
case "$arch" in
    x86_64)
        target="x86_64"
        ;;
    aarch64 | arm64)
        target="arm64"
        ;;
    *)
        echo "Unsupported architecture for neovim binary install: $arch" >&2
        exit 0
        ;;
esac

tarball="nvim-linux-${target}.tar.gz"
url="https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/${tarball}"
download_path="${TEMP_DIR:-/tmp}/${tarball}"

curl -fsSL --connect-timeout 30 --max-time 300 --retry 3 --retry-delay 2 "$url" -o "$download_path" || exit 0

if [[ ! -f "$download_path" ]] || [[ ! -s "$download_path" ]]; then
    exit 0
fi

sudo rm -rf "/opt/nvim-linux-${target}" || true
sudo tar -C /opt -xzf "$download_path" || exit 0
sudo ln -sfn "/opt/nvim-linux-${target}/bin/nvim" /usr/local/bin/nvim || true
