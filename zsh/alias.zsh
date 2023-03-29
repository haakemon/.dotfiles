
# alias
alias lla="exa --all --long --header --git --icons"
alias print-path='echo -e ${PATH//:/\\n}'
alias _cat='command cat'
alias cat=bat
alias _npm='command npm'
alias npm="echo Use pnpm or yarn instead \(or _npm if you really need to use npm\)"
alias gitroot="cd $(git rev-parse --show-toplevel)"

# alias with sudo privileges
alias openports="sudo sysctl -w net.ipv4.ip_unprivileged_port_start=443"
alias synctime="sudo ntpdate time.windows.com"
alias ctop="sudo docker run --rm -ti -v /var/run/docker.sock:/var/run/docker.sock quay.io/vektorlab/ctop:latest"
