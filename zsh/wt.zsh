eval "$(wt config shell init zsh)"

function wt() {
  case "$1" in
    s) shift; command wt switch "$@" ;;
    ls) shift; command wt list "$@" ;;
    new) shift; command wt switch --create "$@" ;;
    *) command wt "$@" ;;
  esac
}
