RED_COLOR=$(tput setaf 1)
GREEN_COLOR=$(tput setaf 2)
YELLOW_COLOR=$(tput setaf 3)
BLUE_COLOR=$(tput setaf 4)
MAGENTA_COLOR=$(tput setaf 5)
RESET_COLOR=$(tput sgr0)

source "${HOME}/.profile"

for var in XDG_STATE_HOME XDG_CACHE_HOME XDG_DATA_HOME; do
  if [[ -z "${(P)var}" ]]; then
    echo "$var is not set - .zshrc not fully initialized"
    return
  fi
done
