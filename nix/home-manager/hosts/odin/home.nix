{ config, pkgs, ... }:

{
  imports = [
    ../../modules/base.nix
    ../../modules/base_headfull.nix
    ../../modules/browsers.nix
    ../../modules/development.nix
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
      pkgs.llama-cpp-vulkan
    ];
  };

  browsers = {
    vivaldi = true;
    firefox = true;
    chromium = true;
    ladybird = true;
    zen = false;
    browsers = false;
  };

  systemd.user.services.steam-bpm-niri = {
    Unit = {
      Description = "Watch for Steam Big Picture Mode and adjust Niri";
      After = [ "graphical-session-pre.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "exec";
      ExecStart = "${config.home.homeDirectory}/.dotfiles/niri/scripts/steam-bpm-niri";
      StandardOutput = "journal";
      Restart = "on-failure";
    };
  };

}
