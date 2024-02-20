{ config, pkgs, ... }:
let
  inherit (import ../options.nix)
    gitUsername
    gitEmail
    userHome
    username
    hostname
    flakeDir
    flakeHash;
in
{
  imports =
    [
      ./auth.nix
      ./zsh.nix
      ./development.nix
    ];

  home.username = "${username}";
  home.homeDirectory = "${userHome}";
  # home.enableDebugInfo = true;

  home.sessionVariables = {
    XDG_DESKTOP_DIR = "${config.home.homeDirectory}/Desktop";
    XDG_DOCUMENTS_DIR = "${config.home.homeDirectory}/Documents";
    XDG_DOWNLOAD_DIR = "${config.home.homeDirectory}/Downloads";
    XDG_MUSIC_DIR = "${config.home.homeDirectory}/Music";
    XDG_PICTURES_DIR = "${config.home.homeDirectory}/Pictures";
    XDG_PUBLICSHARE_DIR = "${config.home.homeDirectory}/Public";
    XDG_TEMPLATES_DIR = "${config.home.homeDirectory}/Templates";
    XDG_VIDEOS_DIR = "${config.home.homeDirectory}/Videos";

    XDG_CACHE_HOME = "${config.home.homeDirectory}/.cache";
    XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
    XDG_DATA_HOME = "${config.home.homeDirectory}/.local/share";
    XDG_STATE_HOME = "${config.home.homeDirectory}/.local/state";

    NUGET_PACKAGES = "${config.home.sessionVariables.XDG_CACHE_HOME}/NuGetPackages";
    DOTNET_CLI_HOME = "${config.home.sessionVariables.XDG_CONFIG_HOME}/.dotnet";
  };

  home.packages = with pkgs; [
    # Browsers
    vivaldi

    # Utils
    gparted
    jotta-cli
    (nerdfonts.override { fonts = [ "VictorMono" ]; })
    victor-mono
    steam-run
    unzip
    libsForQt5.kruler
    headsetcontrol # Set options for headsets

    # Tools
    blender
    wezterm
    obs-studio
    prusa-slicer
    freeoffice
    kooha # screen recorder
    protonvpn-gui
    keymapp

    # Gaming
    heroic

    # Music / video
    spotify
    freetube
    vlc

    # Chat
    telegram-desktop
    discord

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
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';

    ".config/nixpkgs/config.nix".text = ''
      { allowUnfree = true; }
    '';

    ".wezterm.lua".source = config.lib.file.mkOutOfStoreSymlink "${userHome}/.dotfiles/wezterm/.wezterm.lua";
    ".face.icon".source = config.lib.file.mkOutOfStoreSymlink "${userHome}/.dotfiles/sddm/.face.icon";
  };

  # Settings for virt-manager https://nixos.wiki/wiki/Virt-manager
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };

  fonts.fontconfig.enable = true;
  nixpkgs.config.allowUnfree = true;

  programs = {
    home-manager.enable = true;
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
