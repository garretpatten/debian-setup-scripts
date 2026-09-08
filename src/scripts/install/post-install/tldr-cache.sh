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

# Some distro-packaged tealdeer versions (e.g. Debian 12's 1.5.0) cannot
# download the upstream archive. Seed the cache directly from the source repo.
if [[ ! -d "$HOME/.cache/tealdeer/tldr-pages/pages.en" ]] && command -v git >/dev/null 2>&1; then
    rm -rf "$HOME/.cache/tealdeer/tldr-pages"
    git clone --depth 1 https://github.com/tldr-pages/tldr.git \
        "$HOME/.cache/tealdeer/tldr-pages" >/dev/null 2>&1 || true
fi
