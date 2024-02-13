#!/usr/bin/env zsh

DEVENV_DIR="$HOME/.dotfiles/nix/devenv"

_complete_devenv() {
    local curcontext="$curcontext" state line
    typeset -A opt_args
    local -a folders
    folders=(${(f)"$(find "${DEVENV_DIR}" -mindepth 1 -maxdepth 1 -type d -exec basename {} \;)"})
    _describe 'folders' folders
}

get_supported_envs() {
  if [ ! -d "$DEVENV_DIR" ]; then
    echo "Error: $DEVENV_DIR not found."
    return 1
  fi

  local supported_envs=()

  # Populate supported_envs with existing directories in $DEVENV_DIR
  while IFS= read -r -d '' directory; do
    supported_envs+=("$(basename "$directory")")
  done < <(find "$DEVENV_DIR" -mindepth 1 -maxdepth 1 -type d -print0)

  echo "${supported_envs[@]}"
}

devenv() {
  local supported_envs=$(get_supported_envs)
  local argument=$1
  export DEVENV_START_DIR=$(pwd)

  if [[ ! " $supported_envs " =~ " $argument " ]]; then
    echo "Invalid argument. Supported values: $supported_envs"
    return -1
  fi

  cd "$DEVENV_DIR/$argument" || return -1
  nix develop
}

# Register the completion function
compdef _complete_devenv devenv
