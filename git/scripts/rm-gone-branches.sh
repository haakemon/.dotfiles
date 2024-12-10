#!/usr/bin/env bash

# https://gist.github.com/GrayedFox/8250e7a49bfffdb581f6356a43188de2

# first we prune origin to ensure our local list of remote branches is up to date
git remote prune origin

GONE_BRANCHES=$(git branch -vv --no-color | grep 'origin/.*: gone]' | awk '{print $1}')

if [ -z "$GONE_BRANCHES" ]; then
  echo "Could not find any local branches that have a gone remote"
  exit 0
fi

if [ "$1" = "-f" ]; then
  echo "$GONE_BRANCHES" | xargs git branch -D
else
  echo "$GONE_BRANCHES" | xargs git branch -d
  if [ $? -ne 0 ]; then
    FAILED_TO_DELETE="true"
  fi
fi

if [ "$FAILED_TO_DELETE" = "true" ]; then
  echo "error: Some local branches are not fully merged."
  echo "If you are sure you want to delete them, run 'git-glean -f'"
fi

# Handy script when following GitFlow and rebasing, since `git branch --merged main` will never list
# a rebased but merged branch (as their commit history differs).
