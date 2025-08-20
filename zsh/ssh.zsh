#!/usr/bin/env zsh

function load-ssh-keys {
  echo "${YELLOW_COLOR}loading ssh keys...${RESET_COLOR}"
  ssh-add -t 7d

  if [ -e "${HOME}/.ssh/id_ed25519--git" ]; then
    # 10080 minutes = 7 days
    ssh-add -t 7d "${HOME}/.ssh/id_ed25519--git"
  fi
}

isSSHKeysNotLoaded=$(keychain -l)
if [[ "$isSSHKeysNotLoaded" == "The agent has no identities." ]]; then
  eval $(keychain --timeout 10080 --eval --quiet)
  load-ssh-keys
fi
