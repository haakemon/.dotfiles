#!/usr/bin/env zsh

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

HISTFILE=$HOME/.zsh-history
HISTSIZE=10000
SAVEHIST=10000
unsetopt beep

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

source $HOME/.dotfiles/zsh/color.zsh

if [[ "$(uname -r)" =~ microsoft ]]; then
  if [[ -e "$HOME/.dotfiles/zsh/_wsl-instance-name.zsh" ]]; then
    source $HOME/.dotfiles/zsh/_wsl-instance-name.zsh
  fi

  source $HOME/.dotfiles/zsh/wsl.zsh
fi

source $(brew --prefix)/opt/powerlevel10k/powerlevel10k.zsh-theme
source $HOME/.dotfiles/zsh/p10k.zsh
source $HOME/.dotfiles/zsh/zinit.zsh
source $HOME/.dotfiles/zsh/keybindings.zsh
source $HOME/.dotfiles/zsh/pnpm.zsh
source $HOME/.dotfiles/zsh/fnm.zsh
source $HOME/.dotfiles/zsh/alias.zsh

ff # see alias.zsh
start-ssh-agent # see alias.zsh
