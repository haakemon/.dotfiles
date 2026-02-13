# function isSSHKeysLoaded() {
#   local sshAddList=$(ssh-add -l | xargs)

#   if [ "$sshAddList" != "The agent has no identities." ]; then
#     return 1
#   else
#     return 0
#   fi
# }

# function prompt_my_keychain_status() {
#   # Nerd font icons: https://www.nerdfonts.com/cheat-sheet
#   if isSSHKeysLoaded; then
#     p10k segment -b 0 -f 1 -t $'\Uf030b '
#   else
#     p10k segment -b 0 -f 2 -t $'\Uf030b '
#   fi
# }

function prompt_my_fhs() {
  if [ "$FHS" = "1" ]; then
    p10k segment -b 0 -f 1 -t FHS
  fi
}

# function prompt_my_devenv() {
#   if [ "$DEVENV" = "1" ]; then
#     p10k segment -b 0 -f 1 -t DEVENV
#   fi
# }
