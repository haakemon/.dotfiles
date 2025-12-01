{ config
, pkgs
, inputs
, ...
}:

{
  nixpkgs.overlays = [
    inputs.niri.overlays.niri
  ];

  programs = {
    niri.enable = true;
    niri.config = null;
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

}
