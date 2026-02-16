function do-ls {
  # Make sure to use emulate -L zsh or
  # your shell settings and a directory
  # named 'rm' could be deadly
  emulate -L zsh
   if [ -d .git ]; then
    onefetch
  else
    lla
  fi
}

add-zsh-hook chpwd do-ls


preexec() {
  local cmd=$1

  # Early exit for non-SSH commands
  [[ $cmd =~ ^(g|git|ssh|scp|sftp|rsync) ]] || return

  # Agent not running - try to start if logged in
  if ! pass-cli test &>/dev/null 2>&1; then
      pass-cli-login
  fi
}
