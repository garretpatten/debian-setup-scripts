#!/bin/bash

### Payloads ###

# Payloads All the Things
git clone https://github.com/swisskyrepo/PayloadsAllTheThings ~/Hacking

# SecLists
git clone https://github.com/danielmiessler/SecLists ~/Hacking

### Tools ###

# Burp Suite
if [[ ! -f "/usr/bin/burpsuite" ]]; then
    # TODO
fi

# Network Mapper
if [[ ! -f "/usr/bin/nmap" ]]; then
    sudo apt install nmap -y
fi

# ZAP
if [[ ! -f "/usr/bin/zaproxy" ]]; then
    flatpak install flathub org.zaproxy.ZAP
fi
