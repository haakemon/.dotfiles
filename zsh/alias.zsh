
# alias
alias lla="exa --all --long --header --git --icons"
alias print-path='echo -e ${PATH//:/\\n}'
alias _cat='command cat'
alias cat=bat
alias _npm='command npm'
alias npm="echo Use pnpm or yarn instead \(or _npm if you really need to use npm\)"
alias _docker='command docker'
alias docker="echo Use podman \(or _docker if you really need to use docker\)"

# alias with sudo privileges
alias openports="sudo sysctl -w net.ipv4.ip_unprivileged_port_start=443"
alias synctime="sudo ntpdate time.windows.com"
alias ctop="sudo docker run --rm -ti -v /var/run/docker.sock:/var/run/docker.sock quay.io/vektorlab/ctop:latest"

function goto {
  typeset -A globalLocations=(
    gitroot 'Root of git repository'
    dotfiles "$HOME/.dotfiles"
    home $HOME
    code "$HOME/Code"
    temp "$HOME/temp"
  )

  if [[ "$1" == 'gitroot' ]]; then
    local gitroot=$(git rev-parse --show-toplevel)
    cd "$gitroot" || return
  elif [[ -n "${globalLocations[$1]}" ]]; then
    cd "${globalLocations[$1]}" || return
  else
    echo "Invalid location parameter '$1'"
    echo "Valid locations:"
    for key in "${(@k)globalLocations}"; do
      printf "%-10s %s\n" "  $key:" "${globalLocations[$key]}"
    done
  fi
}
