#!/bin/bash

# Firewall policy (runs after packages from install/security.sh).

# shellcheck source=../utils.sh
source "$(dirname "$0")/../utils.sh"

if ! command -v ufw >/dev/null 2>&1; then
    exit 0
fi

sudo ufw --force reset 2>>"$ERROR_LOG_FILE" || true
sudo ufw default deny incoming 2>>"$ERROR_LOG_FILE" || true
sudo ufw default allow outgoing 2>>"$ERROR_LOG_FILE" || true
sudo ufw allow ssh 2>>"$ERROR_LOG_FILE" || true

# LocalSend
sudo ufw allow 53317/udp 2>>"$ERROR_LOG_FILE" || true
sudo ufw allow 53317/tcp 2>>"$ERROR_LOG_FILE" || true

# Docker DNS on host
sudo ufw allow in proto udp from 172.16.0.0/12 to 172.17.0.1 port 53 comment 'allow-docker-dns' 2>>"$ERROR_LOG_FILE" || true
sudo ufw allow in proto udp from 192.168.0.0/16 to 172.17.0.1 port 53 comment 'allow-docker-dns' 2>>"$ERROR_LOG_FILE" || true

sudo ufw --force enable 2>>"$ERROR_LOG_FILE" || true

if command -v ufw-docker >/dev/null 2>&1; then
    sudo ufw-docker install 2>>"$ERROR_LOG_FILE" || true
    sudo ufw reload 2>>"$ERROR_LOG_FILE" || true
fi
