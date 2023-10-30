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

# Many tools/dev envs require binding to either 80 or 443. To avoid fighting with sudo and ports, just allow any process to bind from port 80 and upwards
# instead of the default 1024 and upwards.
function open_ports {
  config_value="net.ipv4.ip_unprivileged_port_start=80"

  # Check if the value already exists in /etc/sysctl.conf
  if grep -Fxq "${config_value}" /etc/sysctl.conf; then
    return 0
  fi

  # Append the new value path to /etc/sysctl.conf using echo and sudo
  echo "Trying to add '${config_value}' to /etc/sysctl.conf."
  sudo bash -c "echo '${config_value}' >> /etc/sysctl.conf"

  # Verify if the value path was successfully added
  if grep -Fxq "${config_value}" /etc/sysctl.conf; then
    echo "The value '${config_value}' was added to /etc/sysctl.conf."
  else
    echo "Failed to add the value '${config_value}' to /etc/sysctl.conf."
    exit 1
  fi
}

# Sometimes you get "Exec format error" when trying to execute an executable from Windows within WSL. This function will fix it.
# See https://github.com/microsoft/WSL/issues/8952#issuecomment-1568212651
function fixExecFormatError {
  sudo sh -c 'echo :WSLInterop:M::MZ::/init:PF > /usr/lib/binfmt.d/WSLInterop.conf'
  sudo systemctl unmask systemd-binfmt.service
  sudo systemctl restart systemd-binfmt
  sudo systemctl mask systemd-binfmt.service
}
