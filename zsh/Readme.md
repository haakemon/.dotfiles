# Setting up

Prepare the terminal, by installing a nerd font (https://www.nerdfonts.com/), f.ex `MesloLGM Nerd Font Mono` and set the terminal to use that.

Execute `_setup.sh` to install homebrew and some packages, and setup zsh.

## WSL

Add this to `/etc/wsl.conf`, to set the default user
```
[user]
default=USERNAME
```

Add this to `/etc/wsl.conf`, if you need systemd
```
[boot]
systemd=true
```
