# Setting up

Prepare the terminal, by installing a nerd font (https://www.nerdfonts.com/), f.ex `MesloLGM NF` and set the terminal to use that

## Brew

Install brew, execute: `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`

`brew analytics off`

### Install packages:

`brew install zsh`
create a `.zshrc` in `~`, and add `eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"` so brew is available
set zsh as default shell, execute `chsh -s /home/linuxbrew/.linuxbrew/bin/zsh`, add `/home/linuxbrew/.linuxbrew/bin/zsh` to `/etc/shells` if you get an error saying its not valid as a shell
add `source $HOME/.dotfiles/zsh/.zshrc` to `~/.zshrc` to enable all zsh features from this repo

`brew install fnm fzf exa viu bat git-delta grc kube-ps1 kubectx kubernetes-cli lego podman podman-compose k9s bc gh`




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
