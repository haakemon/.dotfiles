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
    # niri.settings = {
    #     outputs."eDP-1".scale = 2.0;
    #   };
  };

  home.packages = [
    # Utils
    pkgs.jotta-cli
    pkgs.headsetcontrol # Set options for headsets

    # Tools
    # pkgs.blender
    pkgs.obs-studio
    pkgs.prusa-slicer
    pkgs.plasticity
    pkgs.gitbutler

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

  home.file = {
    ".face.icon".source = config.lib.file.mkOutOfStoreSymlink "${config.configOptions.userHome}/.dotfiles/sddm/.face.icon";
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.
}
