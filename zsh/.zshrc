#!/usr/bin/env zsh

HISTFILE="${HOME}/.zsh-history"
HISTSIZE=10000
SAVEHIST=10000
unsetopt beep

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

source "$(brew --prefix)/opt/powerlevel10k/powerlevel10k.zsh-theme"
source "${HOME}/.dotfiles/zsh/colors.zsh"
source "${HOME}/.dotfiles/zsh/p10k.zsh"
source "${HOME}/.dotfiles/zsh/zinit.zsh"
source "${HOME}/.dotfiles/zsh/keybindings.zsh"
source "${HOME}/.dotfiles/zsh/fnm.zsh"
source "${HOME}/.dotfiles/zsh/alias.zsh"

if [[ "$(uname -r)" =~ microsoft ]]; then
  source "${HOME}/.dotfiles/zsh/wsl.zsh"
fi

ff # see alias.zsh

# 10080 minutes = 7 days
eval `keychain --agents ssh --timeout 10080 --eval --quiet`
