#!/usr/bin/env zsh

# WSL specific utility helpers

# Since we dont have access to Windows PATH elements (see /etc/wsl.conf interop section), add some tools that is common to use from WSL
alias explorer="/mnt/c/Windows/explorer.exe"

# Some other tools, like VS Code or sublime merge should be started on the Windows side, but install location differs, and is commonly placed in the user folder.
# These should be added to ~/.zshrc instead, after sourcing ~/.dotfiles/zsh/.zshrc
# export PATH=$PATH:"/mnt/c/Program Files/Sublime Merge"
# export PATH=$PATH:"/mnt/c/Users/n652053/AppData/Local/Programs/Microsoft VS Code/bin"

# Useful to notify that IP of WSL instance has changed, add the expected ip to MACHINE_EXPECTED_IP, and execute check_ip to check
check_ip() {
  local MACHINE_ACTUAL_IP=$(hostname -I | xargs | awk '{print $1}') # Pipe to xargs to trim value

  if [[ -z "${MACHINE_EXPECTED_IP}" ]]; then
    echo "${YELLOW_COLOR}MACHINE_EXPECTED_IP is not set${RESET_COLOR}"
  else
    if [[ $MACHINE_EXPECTED_IP != $MACHINE_ACTUAL_IP ]]; then
      echo "${RED_COLOR}IP has changed${RESET_COLOR}"
      echo "${RED_COLOR}expected: ${MACHINE_EXPECTED_IP}${RESET_COLOR}"
      echo "${RED_COLOR}actual:   ${MACHINE_ACTUAL_IP}${RESET_COLOR}"
    fi
  fi
}
