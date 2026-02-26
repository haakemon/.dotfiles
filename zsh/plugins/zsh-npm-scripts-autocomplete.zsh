# https://github.com/grigorii-zander/zsh-npm-scripts-autocomplete

# Get the directory where this script is located
# ${0:A:h} expands to the absolute path of the directory containing this file
__zna_pwd="${0:A:h}"

__znsaGetScripts() {
  local pkgJson="$1"
  node "$__zna_pwd/getScripts.js" "$pkgJson" 2>/dev/null
}

__znsaFindFile() {
  local filename="$1"
  local dir=$PWD

  while [ ! -e "$dir/$filename" ]; do
    dir=${dir%/*}
    [[ "$dir" = "" ]] && break
  done

  [[ ! "$dir" = "" ]] && echo "$dir/$filename"
}

__znsaArgsLength() {
  echo "$#words"
}

## Completion for pnpm run
__znsaPnpmRunCompletion() {
  [[ ! "$(__znsaArgsLength)" = "3" ]] && return

  local pkgJson="$(__znsaFindFile package.json)"
  [[ "$pkgJson" = "" ]] && return

  local -a options
  options=(${(f)"$(__znsaGetScripts $pkgJson)"})
  [[ "$#options" = 0 ]] && return

  _describe 'values' options
}

compdef __znsaPnpmRunCompletion pnpm
