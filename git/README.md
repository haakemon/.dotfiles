# Git

> [!CAUTION]
> Several of the more advanced aliases were originally written for "git bash for Windows", so they may not work properly on other OS'es because of syntax issues.

To add these configs to local git install, execute:

```shell
git config --global --add include.path "$HOME/.dotfiles/git/.gitconfig-settings"
```

## Signed commits

Execute to add enforced signing of commits to local git install:

```shell
git config --global --add include.path "$HOME/.dotfiles/git/.gitconfig-signing"
```

This requires that you have set up a ssh key named `id_ed25519--git` and a file called `allowed_signers` located in `~/.ssh/`.

See more details about signing of commits with ssh keys: <https://blog.dbrgn.ch/2021/11/16/git-ssh-signatures/>

## Fix line endings in a repo

If line endings are checked out incorrectly, you can execute the following commands to renormalize the line endings.
Ensure that the working directory is clean before executing.

```shell
git rm -rf --cached .
git reset --hard HEAD
```

## Windows stuff

To ensure that git wont ask for passphrase on each git command on Windows, you should set the environment variale `GIT_SSH` to the path of your ssh install (get the path with `which ssh.exe`). This will ensure git and the rest of the system uses the same ssh instance, and you can use `ssh-add` to add all keys to the keychain.
