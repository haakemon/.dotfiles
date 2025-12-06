{ config, pkgs, ... }:

{
  imports = [
    ../../modules/base.nix
    ../../modules/base_headfull.nix
    ../../modules/browsers.nix
    ../../modules/development.nix
    ../../modules/git.nix
    ../../modules/hypridle.nix
    ../../modules/hyprlock.nix
    ../../modules/mitmproxy.nix
    ../../modules/noctalia.nix
    ../../modules/obs-studio.nix
    ../../modules/qmk.nix
    ../../modules/zsh.nix
    ../../modules/niri.nix
  ];

  home = {
    stateVersion = "24.05";
    username = config.user-config.name;
    homeDirectory = config.user-config.home;

    packages = [
      pkgs.headsetcontrol
      pkgs.freetube
      pkgs.telegram-desktop
    ];

    file = {
      ".config/niri/config.kdl".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/niri/config.kdl";
      ".config/noctalia/colors.json".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/quickshell/noctalia/odin/colors.json";
      ".config/noctalia/gui-settings.json".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/quickshell/noctalia/odin/gui-settings.json";
      ".config/noctalia/settings.json".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/quickshell/noctalia/odin/settings.json";
    };
  };

  browsers = {
    vivaldi = true;
    firefox = true;
    chromium = true;
    ladybird = true;
    zen = false;
    browsers = false;
  };
}
