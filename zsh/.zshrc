#!/usr/bin/env zsh

HISTFILE=$HOME/.zsh-history
HISTSIZE=10000
SAVEHIST=10000
unsetopt beep

if [[ "$(uname -r)" =~ microsoft ]]; then
  if [[ -e "$HOME/.dotfiles/zsh/_wsl-instance-name.zsh" ]]; then
    source $HOME/.dotfiles/zsh/_wsl-instance-name.zsh
  else
    read "iiname?WSL instance name: "

    echo "#!/usr/bin/env zsh" > $HOME/.dotfiles/zsh/_wsl-instance-name.zsh
    echo WSL_INSTANCE_NAME=${iiname//[^a-zA-Z0-9]/_} >> $HOME/.dotfiles/zsh/_wsl-instance-name.zsh

    source $HOME/.dotfiles/zsh/_wsl-instance-name.zsh
  fi

  source $HOME/.dotfiles/zsh/wsl.zsh
fi

source $HOME/.dotfiles/zsh/zinit.zsh
source $HOME/.dotfiles/zsh/keybindings.zsh
source $HOME/.dotfiles/zsh/pnpm.zsh
source $HOME/.dotfiles/zsh/fnm.zsh
source $HOME/.dotfiles/zsh/alias.zsh

# Set PATH, MANPATH, etc., for Homebrew.
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

ff
