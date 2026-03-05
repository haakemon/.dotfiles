{ config
, pkgs
, inputs
, ...
}:

{
  programs = {
    niri.enable = true;
  };

  services = {
    gnome.gnome-keyring.enable = true;
  };

  security.polkit.enable = true;
  programs.dconf.enable = true;
  fonts.enableDefaultPackages = true;

  environment.systemPackages = [
    pkgs.xwayland-satellite
    pkgs.wf-recorder # screen recording utility
    pkgs.slurp # screen geometry picker utility
    pkgs.wl-clipboard
    pkgs.xdg-utils
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
}
