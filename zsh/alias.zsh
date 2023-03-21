
#alias
alias lla="exa --all --long --header --git --icons"
alias print-path='echo -e ${PATH//:/\\n}'
alias _cat='command cat'
alias cat=bat
alias _npm='command npm'
alias npm="echo Use pnpm or yarn instead \(or _npm if you really need to use npm\)"
alias fixports="sudo sysctl -w net.ipv4.ip_unprivileged_port_start=443"
alias gitroot="cd $(git rev-parse --show-toplevel)"
