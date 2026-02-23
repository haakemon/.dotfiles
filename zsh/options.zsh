# Zsh options, history, completion, and core configuration

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# History Configuration
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Create history directory if it doesn't exist
[ -d "$XDG_STATE_HOME"/zsh ] || mkdir -p "$XDG_STATE_HOME"/zsh

# History file location (keeping ~ clean)
HISTFILE="$XDG_STATE_HOME"/zsh/history
HISTSIZE=10000
SAVEHIST=10000

# History options
setopt HIST_IGNORE_ALL_DUPS      # Remove older duplicate entries from history
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks from history items
setopt INC_APPEND_HISTORY        # Append to history immediately, not on shell exit
setopt SHARE_HISTORY             # Share history between all sessions
setopt HIST_FIND_NO_DUPS         # Don't show duplicates when searching history
setopt HIST_IGNORE_SPACE         # Don't record commands starting with space

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Completion Configuration
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Create cache directory if it doesn't exist
[ -d "$XDG_CACHE_HOME"/zsh ] || mkdir -p "$XDG_CACHE_HOME"/zsh
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME"/zsh/zcompcache

# Set completion cache location (keeping ~ clean)
export ZSH_COMPDUMP="${XDG_CACHE_HOME}/zsh/.zcompdump-${ZSH_VERSION}"

# Initialize completion system
autoload -Uz compinit

# Load completion with cache
if [[ -n ${ZSH_COMPDUMP}(#qNmh+24) ]]; then
  compinit -d "${ZSH_COMPDUMP}"
else
  compinit -C -d "${ZSH_COMPDUMP}"
fi

# Completion options
setopt ALWAYS_TO_END             # Move cursor to end of word after completion
setopt AUTO_MENU                 # Show completion menu on successive tab press
setopt COMPLETE_IN_WORD          # Complete from both ends of a word
setopt AUTO_LIST                 # Automatically list choices on ambiguous completion

# Completion styling
zstyle ':completion:*' menu select                         # Select completions with arrow keys
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'  # Case insensitive completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"    # Colored completion
zstyle ':completion:*' group-name ''                       # Group results by category

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# General Zsh Options
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

unsetopt BEEP                    # Disable annoying beep
# setopt AUTO_CD                   # cd by typing directory name if it's not a command
setopt AUTO_PUSHD                # Make cd push old directory onto directory stack
setopt PUSHD_IGNORE_DUPS         # Don't push multiple copies of same directory
# setopt EXTENDED_GLOB             # Use extended globbing syntax

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Directory Hashes (Quick Navigation)
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Named directories for quick access with ~name
hash -d code="${HOME}/code"
hash -d dl="${HOME}/Downloads"
hash -d dots="${HOME}/.dotfiles"
hash -d flake="${HOME}/.dotfiles/nix/os"

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Tool Integration
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Initialize zoxide (better cd command)
if command -v zoxide &> /dev/null; then
  eval "$(zoxide init --cmd cd zsh)"
fi

# FZF configuration for better fuzzy finding
if command -v fzf &> /dev/null; then
  export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

  # Use fd for fzf path completion
  _fzf_compgen_path() {
    fd --hidden --exclude .git . "$1"
  }

  # Use fd for fzf directory completion
  _fzf_compgen_dir() {
    fd --type=d --hidden --exclude .git . "$1"
  }
fi
