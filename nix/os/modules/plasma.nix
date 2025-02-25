{ config, pkgs, lib, ... }:


{
  services.desktopManager.plasma6.enable = true;
  services.gnome.at-spi2-core.enable = true; # requirement for orca screen reader

  environment.systemPackages = [
    pkgs.kdePackages.kimageformats
    pkgs.kdePackages.sddm-kcm # sddm gui settings
    # pkgs.kdePackages.kcolorchooser
    # pkgs.kdePackages.ghostwriter
    # pkgs.kdePackages.kdenlive
    pkgs.aha # ANSI HTML Adapter
    pkgs.orca # screen reader
  ];

  xdg.portal = {
    enable = true;
    wlr.enable = true;
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

  programs = {
    xwayland.enable = true;
    partition-manager.enable = true; # KDE Partition Manager
  };
}
