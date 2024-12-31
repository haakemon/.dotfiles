#!/usr/bin/env zsh

ags quit

cd ~/.dotfiles/ags
pnpm i

ags run ~/.dotfiles/ags/app.ts
# ags --inspector --config ~/.dotfiles/ags_v1/entry.js
