
HISTFILE=$HOME/.zsh-history
HISTSIZE=10000
SAVEHIST=10000
unsetopt beep

source $HOME/.dotfiles/zsh/wsl.zsh
source $HOME/.dotfiles/zsh/keybindings.zsh
source $HOME/.dotfiles/zsh/znap.zsh
source $HOME/.dotfiles/zsh/pnpm.zsh
source $HOME/.dotfiles/zsh/fnm.zsh
source $HOME/.dotfiles/zsh/alias.zsh

# Set PATH, MANPATH, etc., for Homebrew.
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# oh-my-posh
eval "$(oh-my-posh init zsh --config $HOME/.dotfiles/oh-my-posh/.mytheme.omp.json)"
