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
    pkgs.clipse
    pkgs.emote
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

  # systemd.user.services.niri-flake-polkit = {
  #   description = "PolicyKit Authentication Agent provided by niri-flake";
  #   wantedBy = [ "niri.service" ];
  #   after = [ "graphical-session.target" ];
  #   partOf = [ "graphical-session.target" ];
  #   serviceConfig = {
  #     Type = "simple";
  #     ExecStart = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
  #     Restart = "on-failure";
  #     RestartSec = 1;
  #     TimeoutStopSec = 10;
  #   };
  # };
}
