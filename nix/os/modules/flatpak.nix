{ config, pkgs, ... }:

{
  services = {
    flatpak.enable = true;
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [
      pkgs.xdg-desktop-portal
    ];
    configPackages = [
      pkgs.xdg-desktop-portal
    ];
  };
}
