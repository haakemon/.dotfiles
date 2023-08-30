#!/usr/bin/env zsh

# alias
alias lla="exa --all --long --header --git --icons --group-directories-first"
alias print-path="echo -e ${PATH//:/\\n}"
alias _cat="command cat"
alias cat="bat"
alias _npm="command npm"
alias npm="echo ${YELLOW_COLOR}Use pnpm or yarn instead \(or _npm if you really need to use npm\)${RESET_COLOR}"
alias k="kubectl"
alias gf="git fuzzy"
alias g="git"
alias ff="fastfetch --load-config ${HOME}/.dotfiles/fastfetch/config.conf"
alias hist="fc -li"

alias ssh-gen-rsa="ssh-keygen -t rsa -b 4096 -a 100"
alias ssh-gen-ed="ssh-keygen -t ed25519 -a 100"

# alias with sudo privileges
alias synctime="sudo ntpdate pool.ntp.org"
alias ctop="sudo docker run --rm -ti -v /var/run/docker.sock:/var/run/docker.sock quay.io/vektorlab/ctop:latest"
alias dpsa="sudo docker ps -a --format \"table {{.ID}}\t{{.Names}}\t{{.State}}\t{{.Status}}\t{{.Image}}\""

function goto {
  typeset -A globalLocations=(
    gitroot 'Root of git repository'
    dotfiles "${HOME}/.dotfiles"
    home $HOME
    code "${HOME}/Code"
    temp "${HOME}/temp"
  )

  if [[ "$1" == 'gitroot' ]]; then
    local gitroot=$(git rev-parse --show-toplevel)
    cd "$gitroot" || return
  elif [[ -n "${globalLocations[$1]}" ]]; then
    cd "${globalLocations[$1]}" || return
  else
    echo "Invalid location parameter '$1'"
    echo "Valid locations:"
    for key in "${(@k)globalLocations}"; do
      printf "%-10s %s\n" "  $key:" "${globalLocations[$key]}"
    done
  fi
}

function load-ssh-keys {
  echo "${YELLOW_COLOR}loading ssh keys...${RESET_COLOR}"
  ssh-add -t 7d # add default keys, valid for 7 days

  if [ -e "${HOME}/.ssh/id_ed25519--git" ]; then
    ssh-add -t 7d "${HOME}/.ssh/id_ed25519--git" # add git signing key if exists, valid for 7 days
  fi
}

function open-ports {
  config_value="net.ipv4.ip_unprivileged_port_start=443"

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
