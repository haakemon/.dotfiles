#!/usr/bin/env zsh

# alias
alias ,,='cd $(git rev-parse --show-toplevel)' # cd to git root
alias ..='cd ..'
alias ...='cd ../..'
alias lla="eza --all --long --group --header --git --icons --group-directories-first --links"
alias tree="eza --all --long --group --header --git --icons --group-directories-first --links --tree"
alias _cat="command cat"
alias cat="bat"
alias _npm="command npm"
alias npm="echo ${YELLOW_COLOR}Use pnpm \(or _npm if you really need npm\)${RESET_COLOR}"
alias k="kubectl"
alias ktx="kubectx"
alias kns="kubens"
alias gf="git fuzzy"
alias g="git"
alias port-listeners="sudo lsof -i -P -n | grep LISTEN"
alias scan="scanimage --device 'escl:https://192.168.2.20:443' --mode Color --resolution 1200dpi --format=png --output-file ${HOME}/scan-$(uuidgen).png --progress"
alias ppsa="podman ps -a --format \"table {{.ID}}\t{{.Names}}\t{{.State}}\t{{.Status}}\t{{.Image}}\""

alias ssh-gen-rsa="ssh-keygen -t rsa -b 4096 -a 100"
alias ssh-gen-ed="ssh-keygen -t ed25519 -a 100"

# alias with sudo privileges
alias synctime="sudo ntpdate pool.ntp.org"
alias ctop="sudo docker run --rm -ti -v /var/run/docker.sock:/var/run/docker.sock quay.io/vektorlab/ctop:latest"
alias dpsa="sudo docker ps -a --format \"table {{.ID}}\t{{.Names}}\t{{.State}}\t{{.Status}}\t{{.Image}}\""


function change_random_bg {
  colors=(
    "#2E1A47"  # Dark purple
    "#1F3B41"  # Dark teal
    "#4B2F2F"  # Dark red-brown
    "#2B3D2F"  # Dark olive green
    "#3E1E5B"  # Dark fuchsia
  )
  RANDOM_COLOR=${colors[$RANDOM % ${#colors[@]}]}
  printf "\033]11;%s\007" "$RANDOM_COLOR"
}

function ssh {
  change_random_bg
  command ssh "$@"
  printf '\x1b]111\x1b\\'
}

function sudo {
  printf "\033]11;#873e23\007"
  command sudo "$@"
  printf '\x1b]111\x1b\\'
}
