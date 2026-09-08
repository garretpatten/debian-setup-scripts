#!/bin/bash

if command -v ghostty >/dev/null 2>&1; then
    exit 0
fi

sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends ghostty || true
