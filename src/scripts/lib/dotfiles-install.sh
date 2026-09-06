#!/bin/bash

# Idempotent copy helpers for the src/dotfiles submodule.
# Mirrors the previous debian config/dev.sh + config/shell.sh copy logic.

expand_home_path() {
    local path="$1"

    if [[ "${path:0:1}" != "~" ]]; then
        printf '%s' "$path"
        return 0
    fi
    if [[ "$path" == "~" ]]; then
        printf '%s' "$HOME"
    elif [[ "${path:1:1}" == "/" ]]; then
        printf '%s/%s' "$HOME" "${path:2}"
    else
        printf '%s' "$path"
    fi
}

copy_dotfile_file() {
    local rel_src="$1"
    local dest
    dest="$(expand_home_path "$2")"
    local src="$PROJECT_ROOT/src/dotfiles/$rel_src"

    [[ -f "$dest" ]] && return 0
    mkdir -p "$(dirname "$dest")"
    cp "$src" "$dest" 2>/dev/null || true
}

copy_dotfile_directory() {
    local rel_src="$1"
    local dest
    dest="$(expand_home_path "$2")"
    local src="$PROJECT_ROOT/src/dotfiles/$rel_src"

    [[ ! -d "$src" ]] && return 0
    [[ -d "$dest" ]] && return 0
    mkdir -p "$(dirname "$dest")"
    cp -r "$src" "$dest" 2>/dev/null || true
}

# Copy src/dotfiles/config/<app>/ → ~/.config/<app>/ when the destination does not exist.
copy_dotfiles_xdg_config_dirs() {
    local root="$PROJECT_ROOT/src/dotfiles"
    local config_dir="$root/config"
    [[ -d "$config_dir" ]] || return 0

    shopt -s nullglob
    local xdg="${XDG_CONFIG_HOME:-$HOME/.config}"
    mkdir -p "$xdg"

    local dir name
    for dir in "$config_dir/"*/; do
        [[ -d "$dir" ]] || continue
        name="$(basename "${dir%/}")"
        copy_dotfile_directory "config/$name" "${xdg}/${name}"
    done
    shopt -u nullglob
}

install_dotfiles_from_manifest() {
    local manifest="$1"
    local line kind rel_src dest

    while IFS= read -r line || [[ -n "$line" ]]; do
        [[ "$line" =~ ^[[:space:]]*# ]] && continue
        [[ -z "${line// /}" ]] && continue

        read -r kind rel_src dest <<< "$line"
        if [[ "$kind" == file ]]; then
            copy_dotfile_file "$rel_src" "$dest"
        fi
    done < "$manifest"
}

# Cache the dotfiles checkout path so home/.zshrc can resolve $DOTFILES.
ensure_dotfiles_path_cache() {
    local dotfiles_root="$PROJECT_ROOT/src/dotfiles"
    local dotfiles_path_file="$HOME/.dotfiles_path"

    if [[ -d "$dotfiles_root/home/zsh" ]]; then
        if [[ ! -f "$dotfiles_path_file" ]]; then
            printf '%s\n' "$dotfiles_root" >"$dotfiles_path_file" 2>/dev/null || true
        else
            local existing_root=""
            IFS= read -r existing_root <"$dotfiles_path_file" || true
            if [[ -z "$existing_root" ]] || [[ ! -d "$existing_root/home/zsh" ]]; then
                printf '%s\n' "$dotfiles_root" >"$dotfiles_path_file" 2>/dev/null || true
            fi
        fi
    fi
}
