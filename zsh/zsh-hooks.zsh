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
