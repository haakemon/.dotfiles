{ config, pkgs, ... }:

{
  programs = {
    git = {
      enable = true;
      delta = {
        enable = true;
      };
      extraConfig = {
        user = {
          name = "${config.configOptions.git.username}";
          email = "${config.configOptions.git.email}";
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
}
