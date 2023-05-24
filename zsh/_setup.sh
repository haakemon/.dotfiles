#!/usr/bin/env bash

sudo apt update
sudo apt install build-essential procps curl file git -y # https://docs.brew.sh/Homebrew-on-Linux#requirements

if [[ $EUID -eq 0 ]]; then
  echo "This script should not be run as the root user. Aborting."
  exit 1
fi


if [ -e "$HOME/.zshrc" ]; then
  echo "The file $HOME/.zshrc already exists. Remove it before continuing."
  exit 2
fi

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo "eval \"\$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)\"" > $HOME/.zshrc
echo "source \$HOME/.dotfiles/zsh/.zshrc" >> $HOME/.zshrc


function add-zsh-to-shells {
  zsh_shell_path="/home/linuxbrew/.linuxbrew/bin/zsh"

  # Check if the shell already exists in /etc/shells
  if grep -Fxq "$zsh_shell_path" /etc/shells; then
    echo "The shell '$zsh_shell_path' already exists in /etc/shells."
    return 0
  fi

  # Append the new shell path to /etc/shells using echo and sudo
  sudo bash -c "echo '$zsh_shell_path' >> /etc/shells"

  # Verify if the shell path was successfully added
  if grep -Fxq "$zsh_shell_path" /etc/shells; then
    echo "The shell '$zsh_shell_path' was added to /etc/shells."
  else
    echo "Failed to add the shell '$zsh_shell_path' to /etc/shells."
    exit 1
  fi
}

add-zsh-to-shells

brew analytics off
brew install zsh \
             fnm \
             fzf \
             exa \
             viu \
             bat \
             git-delta \
             grc \
             kube-ps1 \
             kubectx \
             kubernetes-cli \
             lego \
             podman \
             podman-compose \
             k9s \
             bc \
             gh \
             fastfetch \
             romkatv/powerlevel10k/powerlevel10k \
             #  starship \

chsh -s /home/linuxbrew/.linuxbrew/bin/zsh

zsh

source $HOME/.zshrc