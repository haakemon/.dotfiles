#!/usr/bin/env zsh

function isSSHKeysLoaded() {
  local keychainOutput=$(keychain -l)

  if [ "$keychainOutput" != "The agent has no identities." ]; then
    return 1
  else
    return 0
  fi
}

function prompt_my_keychain_status() {
  # Nerd font icons: https://www.nerdfonts.com/cheat-sheet
  if isSSHKeysLoaded; then
    p10k segment -b 0 -f 1 -t $'\Uf030b'
  else
    p10k segment -b 0 -f 2 -t $'\Uf030b'
  fi
}
