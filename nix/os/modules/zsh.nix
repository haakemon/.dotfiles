{ config, pkgs, lib, ... }:

{
  programs = {
    zsh = {
      enable = true;
      enableBashCompletion = true;
    };
    fzf = {
      fuzzyCompletion = true;
      keybindings = true;
    };
  };
}
