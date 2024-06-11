{ config, pkgs, lib, ... }:


{
  services.desktopManager.plasma6.enable = true;
  gnome.at-spi2-core.enable = true; # requirement for orca screen reader

  environment.systemPackages = [
    pkgs.kdePackages.kimageformats
    pkgs.kdePackages.sddm-kcm # sddm gui settings
    pkgs.aha # ANSI HTML Adapter
  ];

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-kde
      pkgs.xdg-desktop-portal
    ];
    configPackages = [
      pkgs.xdg-desktop-portal-kde
      pkgs.xdg-desktop-portal
    ];
  };

  programs = {
    xwayland.enable = true;
    partition-manager.enable = true; # KDE Partition Manager
    kdeconnect.enable = true;
  };
}
