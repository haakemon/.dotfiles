{ config, pkgs, ... }:

{
  imports =
    [
      ../../../modules/home-manager/base.nix
      ../../../modules/home-manager/git.nix
      ../../../modules/home-manager/security.nix
      ../../../modules/home-manager/development.nix
    ];

  programs = {
    home-manager.enable = true;
  };

  gtk.enable = true;
  gtk.theme.name = "adw-gtk3-dark";
  gtk.cursorTheme.name = "Banana";
  gtk.cursorTheme.size = 36;
  # gtk.cursorTheme = {
  #     package = pkgs.banana-cursor;
  #     name = "Banana";
  #     size = 36;
  #   };

  gtk.iconTheme.name = "Dracula";

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  home = {
    packages = [
      # Utils
      pkgs.jotta-cli
      pkgs.headsetcontrol # Set options for headsets

      # Tools
      # pkgs.blender
      pkgs.obs-studio
      pkgs.prusa-slicer
      pkgs.plasticity
      # pkgs.gitbutler

      # Gaming
      pkgs.heroic

      # Music / video
      pkgs.spotify
      pkgs.freetube
      pkgs.vlc

      # Chat
      pkgs.telegram-desktop
      pkgs.vesktop

      (
        let base = pkgs.appimageTools.defaultFhsEnvArgs; in
        pkgs.buildFHSUserEnv (base // {
          name = "fhs";
          targetPkgs = pkgs: (base.targetPkgs pkgs) ++ [ pkgs.pkg-config ];
          profile = "export FHS=1";
          runScript = "zsh";
          extraOutputsToInstall = [ "dev" ];
        })
      )
    ];

    file = {
      ".face.icon".source = config.lib.file.mkOutOfStoreSymlink "${config.configOptions.userHome}/.dotfiles/sddm/.face.icon";
      ".config/niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "${config.configOptions.userHome}/.dotfiles/niri/config.kdl";

      ".icons/Banana".source = config.lib.file.mkOutOfStoreSymlink "${pkgs.banana-cursor}/share/icons/Banana";
      ".icons/Dracula".source = config.lib.file.mkOutOfStoreSymlink "${pkgs.dracula-icon-theme}/share/icons/Dracula";
    };

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    stateVersion = "24.05"; # Please read the comment before changing.
  };
}
