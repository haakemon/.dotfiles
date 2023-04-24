#!/usr/bin/env zsh

HISTFILE=$HOME/.zsh-history
HISTSIZE=10000
SAVEHIST=10000
unsetopt beep

source $HOME/.dotfiles/zsh/wsl.zsh
source $HOME/.dotfiles/zsh/zinit.zsh
source $HOME/.dotfiles/zsh/keybindings.zsh
source $HOME/.dotfiles/zsh/pnpm.zsh
source $HOME/.dotfiles/zsh/fnm.zsh
source $HOME/.dotfiles/zsh/alias.zsh

# Set PATH, MANPATH, etc., for Homebrew.
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

fastfetch
