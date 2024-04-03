{ config, pkgs, ... }:

{
  imports =
    [
      ../../common/home/base.nix
      ../../common/home/git.nix
      ../../common/home/security.nix
      ../../common/home/zsh.nix
      ../../common/home/development.nix
    ];

  programs = {
    home-manager.enable = true;
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

      # Chat
      pkgs.telegram-desktop
      pkgs.slack
      (pkgs.makeAutostartItem { name = "slack"; package = pkgs.slack; })
      pkgs.teams-for-linux
      (pkgs.makeAutostartItem { name = "teams-for-linux"; package = pkgs.teams-for-linux; })

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
