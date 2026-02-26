

source "${HOME}/.dotfiles/zsh/env.zsh"

source "${HOME}/.dotfiles/zsh/options.zsh"

source "${HOME}/.dotfiles/zsh/plugins.zsh"

source "${HOME}/.dotfiles/zsh/p10k.zsh"
source "${HOME}/.dotfiles/zsh/p10k-extensions.zsh"
source "${HOME}/.dotfiles/zsh/keybindings.zsh"
source "${HOME}/.dotfiles/zsh/alias.zsh"
source "${HOME}/.dotfiles/zsh/grc.zsh"
source "${HOME}/.dotfiles/zsh/fnm.zsh"
source "${HOME}/.dotfiles/zsh/zsh-hooks.zsh"
source "${HOME}/.dotfiles/zsh/scripts.zsh"
source "${HOME}/.dotfiles/zsh/plugins/zsh-npm-scripts-autocomplete.zsh"

fastfetch

eval "$(direnv hook zsh)"
