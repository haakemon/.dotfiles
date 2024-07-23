#!/usr/bin/env zsh

ags --quit

cd ~/.dotfiles/ags
pnpm run build

ags --config ~/.dotfiles/ags/entry.js
# ags --inspector --config ~/.dotfiles/ags/entry.js
