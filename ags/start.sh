#!/usr/bin/env sh

ags quit

nohup ags run ~/.dotfiles/ags/app.ts > ~/.dotfiles/ags/nohup.ags.out 2>&1 &
# ags run ~/.dotfiles/ags/app.ts
