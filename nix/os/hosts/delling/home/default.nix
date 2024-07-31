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
    zsh = {
      initExtra = ''
        #region default initExtra
        source "''${HOME}/work/env.zsh"
        #endregion default initExtra
      '';
    };
  };

  home = {
    packages = [
      # Utils
      pkgs.headsetcontrol # Set options for headsets
      pkgs.gcalcli

      # Tools
      pkgs.obs-studio
      pkgs.otpclient

      # Music / video
      pkgs.spotify
      pkgs.freetube
      pkgs.vlc

      # Devtools
      pkgs.azure-cli
      pkgs.kubectl
      pkgs.kubectx
      pkgs.vault

      # Chat
      pkgs.telegram-desktop
      pkgs.slack
      # (pkgs.makeAutostartItem { name = "slack"; package = pkgs.slack; })
      pkgs.teams-for-linux
      # (pkgs.makeAutostartItem { name = "teams-for-linux"; package = pkgs.teams-for-linux; })
    ];

    file = {
      ".face.icon".source = config.lib.file.mkOutOfStoreSymlink "${config.configOptions.userHome}/.dotfiles/sddm/.face.icon";
      ".config/niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "${config.configOptions.userHome}/.dotfiles/niri/config-delling.kdl";

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
