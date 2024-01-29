# [Nix Develop](https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-develop)

`nix develop` is meant to be part of the project code, but because it copies all content in the directory to the store, I've added them in empty directories instead. This way no content will be copied to the store, but you will still get the proper tools installed.

There is an additional bash function `devenv` listed in `zsh/alias.zsh` to easily start the different environments. This function takes one argument, which is the folder names within `.dotfiles/nixos/devenv`. For example, to start the `Node` development environment, execute `devenv node`.
