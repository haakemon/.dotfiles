{ config, pkgs, ... }:
{
  environment.sessionVariables = {
    NH_FLAKE = "path:/home/${config.user-config.name}/.dotfiles/nix/os";
  };
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 10d --keep 7";
  };
}
