#!/usr/bin/env zsh

# 10080 minutes = 7 days
eval $(keychain --agents ssh --timeout 10080 --eval --quiet)

function load-ssh-keys {
  echo "${YELLOW_COLOR}loading ssh keys...${RESET_COLOR}"
  ssh-add -t 7d

  if [ -e "${HOME}/.ssh/id_ed25519--git" ]; then
    ssh-add -t 7d "${HOME}/.ssh/id_ed25519--git"
  fi
}
