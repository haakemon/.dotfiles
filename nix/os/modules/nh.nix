{ config, pkgs, ... }:
{
  environment.sessionVariables = {
    NH_OS_FLAKE = "path:/home/${config.user-config.name}/.dotfiles/nix/os";
    NH_HOME_FLAKE = "path:/home/${config.user-config.name}/.dotfiles/nix/home-manager";
  };
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 10d --keep 7";
  };
}
