#!/bin/bash

install_dir="${HOME}/.local/bin"
TEMP_DIR="${TEMP_DIR:-/tmp/debian-setup-omp-$$}"
mkdir -p "$TEMP_DIR" "$install_dir"
install_script="$TEMP_DIR/oh-my-posh-install.sh"

install_oh_my_posh() {
    if command -v oh-my-posh >/dev/null 2>&1; then
        return 0
    fi
    if [[ ! -x "$install_dir/oh-my-posh" ]]; then
        curl -fsSL https://ohmyposh.dev/install.sh -o "$install_script" || return 1
        bash "$install_script" -d "$install_dir" || return 1
    fi
    [[ -x "$install_dir/oh-my-posh" ]]
}

if ! install_oh_my_posh; then
    echo "WARNING: oh-my-posh install failed, retrying once" >&2
    install_oh_my_posh || echo "ERROR: oh-my-posh install failed" >&2
fi
