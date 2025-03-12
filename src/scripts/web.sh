#!/bin/bash

# Brave
if [[ ! -f "/usr/bin/brave-browser" ]]; then
    curl -fsS https://dl.brave.com/install.sh | sh
fi
