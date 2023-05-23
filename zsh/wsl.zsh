#!/usr/bin/env zsh

# WSL specific utility helpers

ACTUAL_HOST_IP=$(ipconfig.exe | grep IPv4 | head -1 | rev | awk '{print $1}' | rev | tr -d '\r')

# Useful to notify that IP of WSL instance has changed, add the expected ip to MACHINE_EXPECTED_IP, and execute check_ip to check
check_ip() {
  local MACHINE_ACTUAL_IP=$(hostname -I | xargs | awk '{print $1}') # Pipe to xargs to trim value
  local RED=$(tput setaf 1)
  local YELLOW=$(tput setaf 3)
  local RESET=$(tput sgr0)


  if [[ -z "$MACHINE_EXPECTED_IP" ]]; then
    echo "${YELLOW}MACHINE_EXPECTED_IP is not set"
  else
    if [[ $MACHINE_EXPECTED_IP != $MACHINE_ACTUAL_IP ]]; then
      echo "${RED}IP has changed${RESET}"
      echo "${RED}expected: ${MACHINE_EXPECTED_IP}${RESET}"
      echo "${RED}actual:   ${MACHINE_ACTUAL_IP}${RESET}"
    fi
  fi
}
