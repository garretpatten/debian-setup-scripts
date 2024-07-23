#!/bin/bash

# Initial system update
sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove -y

# Git
if [[ ! -f "/usr/bin/git" ]]; then
    sudo apt install git -y
fi
