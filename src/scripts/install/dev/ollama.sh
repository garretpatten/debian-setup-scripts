#!/bin/bash
# Ollama install — prefer the official installer, then fall back to a direct binary
# download when the installer does not leave an ollama binary on PATH.

command -v ollama >/dev/null 2>&1 && exit 0

curl -fsSL https://ollama.com/install.sh | sh || true

if command -v ollama >/dev/null 2>&1; then
    exit 0
fi

OLLAMA_VERSION="0.5.7"

arch="$(uname -m)"
case "$arch" in
    x86_64)
        target="amd64"
        ;;
    aarch64 | arm64)
        target="arm64"
        ;;
    *)
        echo "Unsupported architecture for ollama binary install: $arch" >&2
        exit 0
        ;;
esac

archive="ollama-linux-${target}.tgz"
url="https://github.com/ollama/ollama/releases/download/v${OLLAMA_VERSION}/${archive}"
download_path="${TEMP_DIR:-/tmp}/${archive}"

curl -fsSL --connect-timeout 30 --max-time 600 --retry 3 --retry-delay 2 "$url" -o "$download_path" || exit 0

if [[ ! -f "$download_path" ]] || [[ ! -s "$download_path" ]]; then
    exit 0
fi

tar -xzf "$download_path" -C "${TEMP_DIR:-/tmp}" ollama 2>/dev/null || exit 0

if [[ -x "${TEMP_DIR:-/tmp}/ollama" ]]; then
    sudo install -m 755 "${TEMP_DIR:-/tmp}/ollama" /usr/local/bin/ollama || true
fi
