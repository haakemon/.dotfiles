#!/usr/bin/env zsh

ags --quit

cd ~/.dotfiles/ags_v1
pnpm i
pnpm run build

ags --config ~/.dotfiles/ags_v1/entry.js
# ags --inspector --config ~/.dotfiles/ags_v1/entry.js
