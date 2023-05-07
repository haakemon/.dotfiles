If line endings are checked out incorrectly, you can execute the following commands to renormalize the line endings.
Ensure that the working directory is clean before executing.

```
git rm -rf --cached .
git reset --hard HEAD
```


Execute to add config to local git install
```
git config --global --replace-all include.path "$HOME/.dotfiles/git/.gitconfig-settings"
```
