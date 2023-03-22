# WSL specific utility helpers

ACTUAL_HOST_IP=$(ipconfig.exe | grep IPv4 | head -1 | rev | awk '{print $1}' | rev | tr -d '\r')

# Need to call this after $MACHINE_EXPECTED_IP is defined
check_ip() {
  local MACHINE_ACTUAL_IP=$(hostname -I | xargs | awk '{print $1}') # Pipe to xargs to trim value
  local RED='\033[0;31m'
  local NC='\033[0m' # No Color

  # $MACHINE_EXPECTED_IP should be defined in a local .zsh configuration file
  if [[ $MACHINE_EXPECTED_IP != $MACHINE_ACTUAL_IP ]]; then
    echo "${RED}Ubuntu IP has changed, new IP: ${MACHINE_ACTUAL_IP}${NC}"
  fi
}
