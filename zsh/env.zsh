#!/usr/bin/env zsh

HISTFILE="${HOME}/.zsh-history"
HISTSIZE=10000
SAVEHIST=10000

RED_COLOR=$(tput setaf 1)
YELLOW_COLOR=$(tput setaf 3)
RESET_COLOR=$(tput sgr0)

BAT_CONFIG_PATH="${HOME}/.dotfiles/bat/bat.conf"
