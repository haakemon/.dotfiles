#!/usr/bin/env zsh

if ! pass-cli test &>/dev/null; then
  notify-send -u critical "Proton Pass SSH Agent" "Not logged in. Run: pass-cli login"
  exit 78
fi

exec pass-cli ssh-agent start
