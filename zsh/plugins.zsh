#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Zinit Installation & Setup
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Set zinit home directory (keeping ~ clean)
ZINIT_HOME="${XDG_DATA_HOME}/zinit/zinit.git"

# Auto-install zinit if not present
if [[ ! -f "${ZINIT_HOME}/zinit.zsh" ]]; then
  print -P "%F{33}▓▒░ %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
  command mkdir -p "$(dirname $ZINIT_HOME)"
  command git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME" && \
    print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
    print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

# Source zinit
source "${ZINIT_HOME}/zinit.zsh"

# Load zinit completion
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Theme
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Powerlevel10k theme
# Load immediately (not lazy) since it's the prompt
zinit ice depth=1
zinit light romkatv/powerlevel10k

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Plugins
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# zsh-autosuggestions
# Fish-like autosuggestions based on history
zinit ice wait lucid atload'_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions

# zsh-syntax-highlighting
# Fish-like syntax highlighting (load after other plugins)
zinit ice wait lucid atinit'zpcompinit; zpcdreplay'
zinit light zsh-users/zsh-syntax-highlighting

# zsh-fzf-history-search
# Better history search using fzf
zinit ice wait lucid
zinit light joshskidmore/zsh-fzf-history-search

# zsh-npm-scripts-autocomplete
# Autocomplete npm scripts from package.json
zinit ice wait lucid
zinit light grigorii-zander/zsh-npm-scripts-autocomplete

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Additional Zinit Features (Optional)
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Uncomment to enable automatic updates (runs on shell startup once per day)
# zinit self-update

# Uncomment to enable automatic plugin updates
# zinit update --all

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Plugin Notes
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# zinit ice options explained:
# - wait lucid: Load plugin asynchronously after prompt appears (faster startup)
# - depth=1: Shallow clone (faster download)
# - atload: Execute code after plugin loads
# - atinit: Execute code before plugin loads

# To update all plugins: zinit update
# To update specific plugin: zinit update romkatv/powerlevel10k
# To see plugin status: zinit status
# To remove plugin: zinit delete <plugin-name>
