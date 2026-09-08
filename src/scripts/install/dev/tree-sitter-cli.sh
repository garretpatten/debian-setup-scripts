#!/bin/bash
# tree-sitter CLI binary install fallback for Debian releases where the apt package is unavailable.

command -v tree-sitter >/dev/null 2>&1 && exit 0

TREE_SITTER_VERSION="0.24.3"

arch="$(uname -m)"
case "$arch" in
    x86_64)
        target="x64"
        ;;
    aarch64 | arm64)
        target="arm64"
        ;;
    *)
        echo "Unsupported architecture for tree-sitter binary install: $arch" >&2
        exit 0
        ;;
esac

archive="tree-sitter-linux-${target}.gz"
url="https://github.com/tree-sitter/tree-sitter/releases/download/v${TREE_SITTER_VERSION}/${archive}"
download_path="${TEMP_DIR:-/tmp}/${archive}"

curl -fsSL --connect-timeout 30 --max-time 300 --retry 3 --retry-delay 2 "$url" -o "$download_path" || exit 0

if [[ ! -f "$download_path" ]] || [[ ! -s "$download_path" ]]; then
    exit 0
fi

gunzip -c "$download_path" >"${TEMP_DIR:-/tmp}/tree-sitter" 2>/dev/null || exit 0

if [[ -s "${TEMP_DIR:-/tmp}/tree-sitter" ]]; then
    sudo install -m 755 "${TEMP_DIR:-/tmp}/tree-sitter" /usr/local/bin/tree-sitter || true
fi
