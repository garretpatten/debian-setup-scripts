#!/bin/bash

workingDirectory=$1

# Final system update
sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove -y

printf "\n\n============================================================================\n\n"

cat "$workingDirectory/src/assets/wolf.txt"

printf "\n\n============================================================================\n\n"

printf \
"Run the following to enable Docker daemon on startup:
    sudo systemctl start docker.service
    sudo systemctl enable docker.service
    sudo usermod -aG docker %s
    newgrp docker\r" "$USER"

printf "\n\n============================================================================\n\n\r"

printf "Cheers -- system setup is now complete.\n\r"
printf "Log out and log back in to complete shell change.\n"
