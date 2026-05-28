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

  # Check if ssh-agent daemon is running
  local daemon_status
  daemon_status=$(pass-cli ssh-agent daemon status 2>/dev/null)

  if [[ ! $daemon_status =~ "Status:[[:space:]]+running" ]]; then
    # Agent not running - try to start if logged in
    local test_output
    test_output=$(pass-cli test 2>/dev/null)

    if [[ ! $test_output =~ "Connection successful" ]]; then
      pass-cli login
      sleep 2
    fi
    pass-cli ssh-agent daemon start
  fi
}
