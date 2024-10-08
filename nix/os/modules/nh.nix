{ config, pkgs, ... }:
{
  environment.sessionVariables = {
    FLAKE = "path:/home/${config.configOptions.username}/.dotfiles/nix/os";
  };
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 10d --keep 7";
  };
}
