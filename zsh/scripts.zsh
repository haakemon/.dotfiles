function pass-cli-login {
  pass-cli logout
  pass-cli login

  if pass-cli test &>/dev/null; then
    systemctl --user restart proton-pass-agent.service
    notify-send "Proton Pass" "SSH Agent started successfully"
  else
    notify-send -u critical "Proton Pass" "Login failed - SSH Agent not started"
  fi
}
