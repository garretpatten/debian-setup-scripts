#!/bin/bash
# Seed the tealdeer cache after installation.

command -v tldr >/dev/null 2>&1 || exit 0

mkdir -p "$HOME/.cache/tealdeer"

tldr --update || true

# Some tealdeer versions need a first command to create the language-specific tree.
if [[ ! -d "$HOME/.cache/tealdeer/tldr-pages/pages.en" ]]; then
    tldr --list >/dev/null 2>&1 || true
fi

# Final refresh if the cache is still missing.
if [[ ! -d "$HOME/.cache/tealdeer/tldr-pages/pages.en" ]]; then
    tldr --update || true
fi
