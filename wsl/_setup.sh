#!/bin/bash

if [ -e "/etc/wsl.conf" ]; then
    echo "/etc/wsl.conf already exists."
    echo "You can add the content:"
    echo "[user]"
    echo "default=USERNAME"
    echo "to the file manually, then restart the wsl instance (wsl --terminate INSTANCE_NAME)."
    exit 1
else
    read -p "Enter username (the user needs to already exist): " username

    echo "[user]" > /etc/wsl.conf
    echo "default=$username" >> /etc/wsl.conf

    echo "You should now restart the wsl instance (wsl --terminate INSTANCE_NAME), and when logging in again you should now be logged in as $username."
fi
