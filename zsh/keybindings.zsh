#  https://github.com/ohmyzsh/ohmyzsh/blob/master/lib/key-bindings.zsh

bindkey -e

# [Home] - Go to beginning of line
bindkey  "^[[H"   beginning-of-line

# [End] - Go to end of line
bindkey  "^[[F"   end-of-line

# [Ctrl-LeftArrow] - move backward one word
bindkey '^[[1;5D' backward-word

# [Ctrl-RightArrow] - move forward one word
bindkey '^[[1;5C' forward-word

# [Ctrl-Backspace] - delete whole word backwards
bindkey '^H' backward-kill-word

# [Ctrl-Delete] - delete whole word forwards
bindkey '^[[3;5~' kill-word