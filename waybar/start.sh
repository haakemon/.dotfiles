#!/usr/bin/env zsh

pkill waybar

waybar -c ~/.dotfiles/waybar/config.jsonc -s ~/.dotfiles/waybar/style.css
