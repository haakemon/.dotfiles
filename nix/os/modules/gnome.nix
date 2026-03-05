{ config, pkgs, lib, ... }:

{
  services = {
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    gnome = {
      core-apps.enable = false;
      core-developer-tools.enable = false;
      games.enable = false;
    };
  };
  environment.gnome.excludePackages = [
    pkgs.gnome-tour
    pkgs.gnome-user-docs
  ];
}
