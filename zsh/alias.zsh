#!/usr/bin/env zsh

# alias
alias ,,='cd $(git rev-parse --show-toplevel)' # cd to git root
alias ..='cd ..'
alias ...='cd ../..'
alias lla="eza --all --long --group --header --git --icons --group-directories-first"
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

# nix specific stuff
alias nixrebuild="sudo nixos-rebuild --upgrade switch --flake ${HOME}/.dotfiles/nixos"
alias nixrebuild-nocache="sudo nixos-rebuild --upgrade --option eval-cache false switch --flake ${HOME}/.dotfiles/nixos"
alias nixflakeupdate="nix flake update ${HOME}/.dotfiles/nixos"

get_supported_envs() {
  local dotfiles_path="$HOME/.dotfiles/nixos/devenv"

  if [ ! -d "$dotfiles_path" ]; then
    echo "Error: $dotfiles_path not found."
    return 1
  fi

  local supported_envs=()

  # Populate supported_envs with existing directories in $dotfiles_path
  while IFS= read -r -d '' directory; do
    supported_envs+=("$(basename "$directory")")
  done < <(find "$dotfiles_path" -mindepth 1 -maxdepth 1 -type d -print0)

  echo "${supported_envs[@]}"
}

devenv() {
  local supported_envs=$(get_supported_envs)
  local argument=$1

  if [[ ! " $supported_envs " =~ " $argument " ]]; then
    echo "Invalid argument. Supported values: $supported_envs"
    return -1
  fi

  cd "$HOME/.dotfiles/nixos/devenv/$argument"
  nix develop
}
