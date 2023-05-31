If line endings are checked out incorrectly, you can execute the following commands to renormalize the line endings.
Ensure that the working directory is clean before executing.

```
git rm -rf --cached .
git reset --hard HEAD
```


Execute to add config to local git install:
```
git config --global --add include.path "$HOME/.dotfiles/git/.gitconfig-settings"
```

Execute to add enforced signing of commits to local git install:
```
git config --global --add include.path "$HOME/.dotfiles/git/.gitconfig-signing"
```
This requires that you have set up a ssh key named `id_ed25519--git` and a file called `allowed_signers` located in `~/.ssh/`.

See more details about signing of commits with ssh keys: https://blog.dbrgn.ch/2021/11/16/git-ssh-signatures/
