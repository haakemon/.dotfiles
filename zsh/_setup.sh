#!/usr/bin/env bash

sudo apt update
sudo apt install build-essential procps curl file git -y # https://docs.brew.sh/Homebrew-on-Linux#requirements
sudo apt install ntpdate                                 # needed to sync time

if [[ $EUID -eq 0 ]]; then
  echo "This script should not be run as the root user. Aborting."
  exit 1
fi

if [ -e "${HOME}/.zshrc" ]; then
  echo "The file ${HOME}/.zshrc already exists. Backup created as ${HOME}/.zshrc.pre-dotfiles-setup."
  cp ${HOME}/.zshrc ${HOME}/.zshrc.pre-dotfiles-setup
fi

echo "source \$HOME/.dotfiles/zsh/.zshrc" >"${HOME}/.zshrc"

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

function add-zsh-to-shells {
  zsh_shell_path="/home/linuxbrew/.linuxbrew/bin/zsh"

  # Check if the shell already exists in /etc/shells
  if grep -Fxq "${zsh_shell_path}" /etc/shells; then
    echo "The shell '${zsh_shell_path}' already exists in /etc/shells."
    return 0
  fi

  # Append the new shell path to /etc/shells using echo and sudo
  sudo bash -c "echo '${zsh_shell_path}' >> /etc/shells"

  # Verify if the shell path was successfully added
  if grep -Fxq "${zsh_shell_path}" /etc/shells; then
    echo "The shell '${zsh_shell_path}' was added to /etc/shells."
  else
    echo "Failed to add the shell '${zsh_shell_path}' to /etc/shells."
    exit 1
  fi
}

function brewinstall-basics {
  brew tap oven-sh/bun

  brew install zsh \
    zsh-completions \
    pnpm \
    fnm \
    fzf \
    eza \
    viu \
    bat \
    git-delta \
    grc \
    fastfetch \
    romkatv/powerlevel10k/powerlevel10k \
    bc \
    gh \
    keychain \
    tmux \
    bun
}

function brewinstall-container-tools {
  brew install podman \
    podman-compose
}

function brewinstall-kube-tools {
  brew install kube-ps1 \
    kubectx \
    kubernetes-cli \
    k9s
}

add-zsh-to-shells
brew analytics off
brewinstall-basics

# Prompt for container tools installation
read -p "Do you wish to install container tools? [y/N]: " -n 1 -r container_response
echo # newline

# Execute the script for installing container tools if applicable
if [[ $container_response =~ ^[Yy]$ ]]; then
  ./brewinstall-container-tools
fi

# Prompt for Kubernetes tools installation
read -p "Do you wish to install Kubernetes tools? [y/N]: " -n 1 -r kube_response
echo # newline

# Execute the script for installing Kubernetes tools if applicable
if [[ $kube_response =~ ^[Yy]$ ]]; then
  ./brewinstall-kube-tools
fi

chsh -s /home/linuxbrew/.linuxbrew/bin/zsh

zsh

source "${HOME}/.zshrc"

# Symlink tmux config
ln -s ~/.dotfiles/tmux/.tmux.conf ~/.tmux.conf
ln -s ~/.dotfiles/tmux/.tmux-powerlinerc ~/.tmux-powerlinerc
