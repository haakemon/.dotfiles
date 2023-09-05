#!/usr/bin/env zsh

unsetopt beep
source "${HOME}/.dotfiles/zsh/env.zsh"

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

source "$(brew --prefix)/opt/powerlevel10k/powerlevel10k.zsh-theme"
source "${HOME}/.dotfiles/zsh/p10k.zsh"
source "${HOME}/.dotfiles/zsh/p10k-extensions.zsh"
source "${HOME}/.dotfiles/zsh/zinit.zsh"
source "${HOME}/.dotfiles/zsh/keybindings.zsh"
source "${HOME}/.dotfiles/zsh/fnm.zsh"
source "${HOME}/.dotfiles/zsh/alias.zsh"

if [[ "$(uname -r)" =~ microsoft ]]; then
  source "${HOME}/.dotfiles/zsh/wsl.zsh"
fi

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

  autoload -Uz compinit
  compinit
fi

ff # see alias.zsh

# 10080 minutes = 7 days
eval $(keychain --agents ssh --timeout 10080 --eval --quiet)

function do-ls {
  # Make sure to use emulate -L zsh or
  # your shell settings and a directory
  # named 'rm' could be deadly
  emulate -L zsh
  lla
}

add-zsh-hook chpwd do-ls
