{ config, pkgs, ... }:

{
  user-config = {
    name = "haakemon";
  };

  imports = [
    ../../user-options.nix
    ../../system-options.nix

    ../../modules/base.nix
    ../../modules/git.nix
    ../../modules/zsh.nix
  ];

  home = {
    stateVersion = "24.05"; # Please read the comment before changing.

    packages = [
      pkgs.simple-http-server
      pkgs.nodejs_22
      pkgs.pnpm
    ];
  };
}
