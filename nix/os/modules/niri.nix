{ config
, pkgs
, inputs
, ...
}:

{
  imports = [
    ./hyprlock.nix
    ./hypridle.nix
  ];
  nixpkgs.overlays = [
    inputs.niri.overlays.niri
  ];

  programs = {
    niri.enable = true;
  };

  environment.systemPackages = [
    pkgs.xwayland-satellite-unstable
    pkgs.wf-recorder # screen recording utility
    pkgs.slurp # screen geometry picker utility
    pkgs.wl-clipboard
    pkgs.clipse
    pkgs.emote
  ];

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [
      pkgs.kdePackages.xdg-desktop-portal-kde
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal
    ];
    configPackages = [
      pkgs.kdePackages.xdg-desktop-portal-kde
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal
    ];
  };

  home-manager.users.${config.user-config.name} =
    { config, pkgs, ... }:
    {
      home = {
        sessionVariables = {
          ELECTRON_OZONE_PLATFORM_HINT = "wayland";
          NIXOS_OZONE_WL = "1";
        };
      };

      programs = {
        niri.config = null;
      };

      # home = {
      #   file = {
      #     ".config/niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "${config.user-config.home}/.dotfiles/niri/config.kdl";
      #   };
      # };
    };
}
