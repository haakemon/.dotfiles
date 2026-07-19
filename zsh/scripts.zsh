ensure_varlock() {
  # https://varlock.dev
  export PATH="${XDG_CONFIG_HOME:-$HOME/.config}/varlock/bin:$PATH"

  local force=false
  if [[ "$1" == "--force" ]]; then
    force=true
  fi

  if [[ "$force" == true ]] || ! command -v varlock &>/dev/null; then
    curl -sSfL https://raw.githubusercontent.com/dmno-dev/varlock/4e37ef7941c586921cff7cacdfcd90f36ed20943/packages/varlock/install.sh | sh -s
  fi
}

ensure_varlock
