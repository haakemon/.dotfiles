{ config, pkgs, ... }:

{
  imports =
    [
      ../../../modules/home-manager/base.nix
      ../../../modules/home-manager/git.nix
      ../../../modules/home-manager/security.nix
      ../../../modules/home-manager/development.nix
    ];

  home = {
    packages = [
      # Utils
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
