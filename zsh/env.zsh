#!/usr/bin/env zsh

HISTFILE="${HOME}/.zsh-history"
HISTSIZE=10000
SAVEHIST=10000

RED_COLOR=$(tput setaf 1)
GREEN_COLOR=$(tput setaf 2)
YELLOW_COLOR=$(tput setaf 3)
BLUE_COLOR=$(tput setaf 4)
MAGENTA_COLOR=$(tput setaf 5)
RESET_COLOR=$(tput sgr0)

DOTNET_CLI_TELEMETRY_OPTOUT=1

export BAT_CONFIG_PATH="${HOME}/.dotfiles/bat/bat.conf"
