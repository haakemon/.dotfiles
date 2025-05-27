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
      ];

      programs = {
        git = {
          enable = true;
          delta = {
            enable = true;
          };
          extraConfig = {
            user = {
              name = "Håkon Bogsrud";
              email = "2082481+haakemon@users.noreply.github.com";
            };
          };
          includes = [
            { path = "~/.dotfiles/git/.gitconfig-alias"; }
            { path = "~/.dotfiles/git/.gitconfig-color"; }
            { path = "~/.dotfiles/git/.gitconfig-settings"; }
            { path = "~/.dotfiles/git/.gitconfig-signing"; }
          ];
        };
      };
    };
}
