{ config, lib, ... }:

{
  home-manager.users.${config.user-config.name} =
    { config
    , pkgs
    , lib
    , ...
    }:
    {
      home.packages = [
        pkgs.pre-commit
        pkgs.gh # github cli
        pkgs.nixpkgs-fmt # formatting .nix files
        pkgs.nixfmt-rfc-style # formatting .nix files
        pkgs.gcc # requirement for pre-commit nixpkgs-fmt
        pkgs.rustup # requirement for pre-commit nixpkgs-fmt
        pkgs.keychain
        pkgs.delta
      ];

      programs = {
        git = {
          enable = true;
          includes = [
            { path = "~/.dotfiles/git/.gitconfig"; }
          ];
        };
      };
    };
}
