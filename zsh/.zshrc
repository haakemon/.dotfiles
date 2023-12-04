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
source "${HOME}/.dotfiles/zsh/ssh.zsh"
source "${HOME}/.dotfiles/zsh/zsh-hooks.zsh"

if [[ "$(uname -r)" =~ microsoft ]]; then
  source "${HOME}/.dotfiles/zsh/wsl.zsh"
fi

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

  autoload -Uz compinit
  compinit
fi

# Start/Attach to main tmux session by default
# if [[ -z "$TMUX" ]]; then
#   tmx
# fi

ff # see alias.zsh
