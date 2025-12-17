{ config, pkgs, inputs, ... }:
let
  secretspath = builtins.toString inputs.dotfiles-private-nonflake;
in
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
    pkgs.age
    pkgs.sops
  ];

  programs = {
    git = {
      enable = true;
      includes = [
        { path = "~/.dotfiles/git/.gitconfig"; }
      ];
    };
  };

  sops = {
    defaultSopsFile = "${secretspath}/sops/secrets/common.yaml";
    defaultSopsFormat = "yaml";
    age.keyFile = "${config.user-config.home}/.config/sops/age/keys.txt";

    secrets = {
      "ssh/allowed_signers" = {
        path = "${config.user-config.home}/.ssh/allowed_signers";
        mode = "0600";
      };
      "ssh/id_ed25519--git" = {
        path = "${config.user-config.home}/.ssh/id_ed25519--git";
        mode = "0600";
      };
      "ssh/id_ed25519--git.pub" = {
        path = "${config.user-config.home}/.ssh/id_ed25519--git.pub";
        mode = "0644";
      };
    };
  };

}
