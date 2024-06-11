{ config, pkgs, ... }:

{
  nixpkgs.overlays = [
    (self: super: {
      xwayland-satellite = super.callPackage ../apps/xwayland-satellite/package.nix { };
    })
  ];

  programs = {
    niri.enable = true;
    # xwayland.enable = true; # TODO: is this needed?
  };

  environment.systemPackages = [
    pkgs.xwayland-satellite
    pkgs.swaybg
    pkgs.swayidle
  ];

  security.polkit.enable = true;
  security.pam.services.swaylock = {
    text = "auth include login";
  };

  services = {
    blueman.enable = true;
    gnome.gnome-keyring.enable = true;
  };


  # TODO: Is any of this needed?
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [
      # pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
      # pkgs.xdg-desktop-portal
    ];
    configPackages = [
      # pkgs.xdg-desktop-portal-gtk
      #pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gnome
      # pkgs.xdg-desktop-portal
    ];
  };
}
