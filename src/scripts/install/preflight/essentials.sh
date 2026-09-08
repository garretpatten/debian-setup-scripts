#!/bin/bash

sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends git curl wget apt-transport-https ca-certificates gnupg lsb-release software-properties-common || true

# Enable contrib/non-free on legacy sources.list and DEB822 .sources stanzas.
if [[ -f /etc/apt/sources.list ]] && ! grep -qE '\bcontrib\b' /etc/apt/sources.list 2>/dev/null; then
    sudo sed -E -i 's/([[:space:]]main)([[:space:]]*$)/\1 contrib non-free non-free-firmware\2/' /etc/apt/sources.list 2>/dev/null || true
fi

for sources_file in /etc/apt/sources.list.d/*.sources; do
    [[ -f "$sources_file" ]] || continue
    if grep -q '^Components: main$' "$sources_file" 2>/dev/null; then
        sudo sed -i 's/^Components: main$/Components: main contrib non-free non-free-firmware/' "$sources_file" 2>/dev/null || true
    fi
done

sudo apt-get update -y || true
