#!/bin/bash

home="$PROJECT_ROOT/src/dotfiles/home"
if [[ ! -f "$HOME/.tmux.conf" ]]; then
    cp "$home/.tmux.conf" "$HOME/.tmux.conf" 2>/dev/null || true
fi
if [[ ! -f "$HOME/.zshrc" ]]; then
    cp "$home/.zshrc" "$HOME/.zshrc" 2>/dev/null || true
fi
if [[ ! -f "$HOME/.bashrc" ]]; then
    cp "$home/.bashrc" "$HOME/.bashrc" 2>/dev/null || true
fi

# Cache the dotfiles checkout path for home/.zshrc.
dotfiles_root="$PROJECT_ROOT/src/dotfiles"
if [[ -d "$dotfiles_root/home/zsh" ]]; then
    if [[ ! -f "$HOME/.dotfiles_path" ]]; then
        printf '%s\n' "$dotfiles_root" >"$HOME/.dotfiles_path" 2>/dev/null || true
    else
        existing_root=""
        IFS= read -r existing_root <"$HOME/.dotfiles_path" || true
        if [[ -z "$existing_root" ]] || [[ ! -d "$existing_root/home/zsh" ]]; then
            printf '%s\n' "$dotfiles_root" >"$HOME/.dotfiles_path" 2>/dev/null || true
        fi
    fi
fi
