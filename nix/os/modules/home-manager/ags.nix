{ inputs, config, pkgs, ... }:

{
  imports =
    [
      inputs.ags.homeManagerModules.default
    ];

  programs = {
    ags = {
      enable = true;

      # null or path, leave as null if you don't want hm to manage the config
      #configDir = ../ags;
      configDir = null;

      # additional packages to add to gjs's runtime
      extraPackages = [
        pkgs.gtksourceview
        pkgs.webkitgtk
        pkgs.accountsservice
        pkgs.gvfs
      ];
    };
  };
}
