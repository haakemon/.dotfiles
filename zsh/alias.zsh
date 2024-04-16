#!/usr/bin/env zsh

# alias
alias cd="z"
alias ,,='cd $(git rev-parse --show-toplevel)' # cd to git root
alias ..='cd ..'
alias ...='cd ../..'
alias lla="eza --all --long --group --header --git --icons --group-directories-first --links"
alias _cat="command cat"
alias cat="bat"
alias _npm="command npm"
alias npm="echo ${YELLOW_COLOR}Use pnpm \(or _npm if you really need npm\)${RESET_COLOR}"
alias k="kubectl"
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
