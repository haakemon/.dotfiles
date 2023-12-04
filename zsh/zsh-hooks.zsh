#!/usr/bin/env zsh

function do-ls {
  # Make sure to use emulate -L zsh or
  # your shell settings and a directory
  # named 'rm' could be deadly
  emulate -L zsh
  lla
}

add-zsh-hook chpwd do-ls
