#!/usr/bin/env bash

if [ -e "/etc/wsl.conf" ]; then
    echo "/etc/wsl.conf already exists, aborting."
    exit 1
else
    read -p "Enter default WSL username (the user needs to already exist): " username
    read -p "Enter current Windows hostname (case sensitive): " winhostname
    read -p "Enter desired WSL hostname: " hostname

    sudo tee -a /etc/wsl.conf > /dev/null <<EOF
[user]
default=${username}

[network]
generateHosts=false
hostname=${hostname}
EOF

    sudo cp /etc/hosts /etc/hosts.pre-dotfiles-setup
    sudo sed -i "s/${winhostname}/${hostname}/g" /etc/hosts

    echo "You should now restart the wsl instance (wsl --terminate INSTANCE_NAME)."
fi
