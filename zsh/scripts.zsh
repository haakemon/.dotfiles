ensure_varlock() {
  # https://varlock.dev
  export PATH="${XDG_CONFIG_HOME:-~/.config}/varlock/bin:$PATH"

  if ! command -v varlock &>/dev/null; then
    curl -sSfL https://raw.githubusercontent.com/dmno-dev/varlock/43a02c102a936aa61f816c037d3e694ae350ca58/packages/varlock/install.sh | sh -s
  fi
}

ensure_varlock
