#!/usr/bin/env zsh

# WSL specific utility helpers

ACTUAL_HOST_IP=$(ipconfig.exe | grep IPv4 | head -1 | rev | awk '{print $1}' | rev | tr -d '\r')

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
