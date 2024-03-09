{ config, pkgs, lib, ... }:

{
  home.username = "${config.configOptions.username}";
  home.homeDirectory = "${config.configOptions.userHome}";
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

  home.file = {
    ".config/nixpkgs/config.nix".text = ''
      { allowUnfree = true; }
    '';

    ".wezterm.lua".source = config.lib.file.mkOutOfStoreSymlink "${config.configOptions.userHome}/.dotfiles/wezterm/.wezterm.lua";
  };


  home.packages = [
    pkgs.unzip
  ] ++ lib.optionals (!config.configOptions.headless) [
    pkgs.vivaldi
    pkgs.wezterm
    pkgs.freeoffice
    pkgs.kooha # screen recorder
    pkgs.smartmontools
    (pkgs.nerdfonts.override { fonts = [ "VictorMono" ]; })
    pkgs.victor-mono
    pkgs.gparted
  ];

  # Settings for virt-manager https://nixos.wiki/wiki/Virt-manager
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };

  fonts.fontconfig.enable = true;
  nixpkgs.config.allowUnfree = true;
}
