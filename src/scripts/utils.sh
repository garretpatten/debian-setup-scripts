#!/bin/bash

# Global configuration — this file lives at src/scripts/utils.sh
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" || exit 1
readonly SCRIPT_DIR
readonly SCRIPTS_DIR="$SCRIPT_DIR"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)" || exit 1
readonly PROJECT_ROOT
readonly ERROR_LOG_FILE="${PROJECT_ROOT}/setup_errors.log"
readonly TEMP_DIR="/tmp/debian-setup-$$"

# Color codes for output formatting
readonly COLOR_RED='\033[0;31m'
readonly COLOR_NC='\033[0m' # No Color

# Log errors only
log_error() {
    echo -e "${COLOR_RED}[ERROR]${COLOR_NC} $*" >&2
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: $*" >> "$ERROR_LOG_FILE"
}

# Install packages - multi-run safe
install_apt_packages() {
    local packages=("$@")
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y "${packages[@]}" 2>>"$ERROR_LOG_FILE" || {
        log_error "Failed to install packages: ${packages[*]}"
    }
}

# Update apt cache
update_apt_cache() {
    sudo apt-get update -y 2>>"$ERROR_LOG_FILE" || {
        log_error "Failed to update apt cache"
    }
}

# Enable contrib/non-free on legacy sources.list and DEB822 .sources stanzas.
enable_debian_contrib_nonfree() {
    local changed=0
    local sources_file

    if [[ -f /etc/apt/sources.list ]] && ! grep -qE '\bcontrib\b' /etc/apt/sources.list 2>/dev/null; then
        sudo sed -E -i 's/([[:space:]]main)([[:space:]]*$)/\1 contrib non-free non-free-firmware\2/' /etc/apt/sources.list 2>>"$ERROR_LOG_FILE" || true
        changed=1
    fi

    for sources_file in /etc/apt/sources.list.d/*.sources; do
        [[ -f "$sources_file" ]] || continue
        if grep -q '^Components: main$' "$sources_file" 2>/dev/null; then
            sudo sed -i 's/^Components: main$/Components: main contrib non-free non-free-firmware/' "$sources_file" 2>>"$ERROR_LOG_FILE" || true
            changed=1
        fi
    done

    if [[ "$changed" -eq 1 ]]; then
        update_apt_cache
    fi
}

# Create directory
ensure_directory() {
    mkdir -p "$1" 2>>"$ERROR_LOG_FILE" || {
        log_error "Failed to create directory: $1"
    }
}

# Remove empty directory
remove_empty_directory() {
    rmdir "$1" 2>/dev/null || true
}

# Copy file (skip if destination already exists — first-time provisioning only).
copy_file_safe() {
    local source="$1"
    local destination="$2"

    if [[ ! -f "$source" ]] || [[ -f "$destination" ]]; then
        return 0
    fi

    mkdir -p "$(dirname "$destination")"
    cp "$source" "$destination" 2>>"$ERROR_LOG_FILE" || {
        log_error "failed to copy $source to $destination"
    }
}

# Copy directory tree when destination path does not already exist (idempotent provisioning).
copy_directory_safe() {
    local source="$1"
    local destination="$2"

    if [[ ! -d "$source" ]] || [[ -d "$destination" ]]; then
        return 0
    fi

    local dest_dir
    dest_dir=$(dirname "$destination")
    mkdir -p "$dest_dir"
    cp -r "$source" "$destination" 2>>"$ERROR_LOG_FILE" || {
        log_error "failed to copy directory $source to $destination"
    }
}

# Download file
download_file_safe() {
    local url="$1"
    local destination="$2"

    curl -sSL --connect-timeout 30 --max-time 300 --fail --show-error "$url" -o "$destination" 2>>"$ERROR_LOG_FILE" || {
        log_error "Failed to download $url"
        rm -f "$destination" 2>/dev/null || true
        return 1
    }

    if [[ ! -f "$destination" ]] || [[ ! -s "$destination" ]]; then
        log_error "Downloaded file is empty or missing: $destination"
        rm -f "$destination" 2>/dev/null || true
        return 1
    fi
}

# Clone git repository
clone_repository_safe() {
    local repo_url="$1"
    local destination="$2"
    local depth="${3:-}"

    if [[ -d "$destination" ]]; then
        return 0
    fi

    local clone_args=()
    if [[ -n "$depth" ]]; then
        clone_args+=("--depth" "$depth")
    fi

    git clone "${clone_args[@]}" "$repo_url" "$destination" 2>>"$ERROR_LOG_FILE" || {
        log_error "Failed to clone repository $repo_url"
    }
}

# GNOME gsettings helpers — only when desktop schemas are installed (e.g. not on minimal/CI images).
gsettings_ok() {
    command -v gsettings >/dev/null 2>&1 || return 1
    [[ -S "/run/user/$(id -u)/bus" ]] || return 1
    gsettings list-schemas 2>/dev/null | grep -qx org.gnome.desktop.interface
}

gsettings_set() {
    gsettings set "$@" 2>>"$ERROR_LOG_FILE" || true
}

gsettings_schema_exists() {
    gsettings list-schemas 2>/dev/null | grep -qx "$1"
}

# True when a graphical login session is active. Restarting systemd-logind then
# terminates GNOME/Wayland sessions — avoid during desktop provisioning.
graphical_login_active() {
    if [[ -n "${DISPLAY:-}" || -n "${WAYLAND_DISPLAY:-}" ]]; then
        return 0
    fi
    case "${XDG_SESSION_TYPE:-}" in
        x11 | wayland) return 0 ;;
    esac
    if command -v loginctl >/dev/null 2>&1; then
        local sid stype
        while read -r sid _; do
            [[ -n "$sid" ]] || continue
            stype=$(loginctl show-session "$sid" -p Type --value 2>/dev/null) || continue
            case "$stype" in
                x11 | wayland) return 0 ;;
            esac
        done < <(loginctl list-sessions --no-legend 2>/dev/null)
    fi
    return 1
}

# Create temporary directory
mkdir -p "$TEMP_DIR"

# Export functions and variables for use in other scripts
export -f log_error install_apt_packages update_apt_cache enable_debian_contrib_nonfree ensure_directory remove_empty_directory
export -f copy_file_safe copy_directory_safe download_file_safe clone_repository_safe
export -f gsettings_ok gsettings_set gsettings_schema_exists graphical_login_active
export PROJECT_ROOT SCRIPT_DIR SCRIPTS_DIR ERROR_LOG_FILE TEMP_DIR
