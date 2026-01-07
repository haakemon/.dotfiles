{ config, pkgs, lib, ... }:


{
  services.desktopManager.plasma6.enable = true;

  environment.systemPackages = [
    pkgs.kdePackages.kimageformats
    pkgs.kdePackages.sddm-kcm # sddm gui settings
    # pkgs.kdePackages.kcolorchooser
    # pkgs.kdePackages.ghostwriter
    # pkgs.kdePackages.kdenlive
    pkgs.aha # ANSI HTML Adapter
  ];

  programs = {
    partition-manager.enable = true; # KDE Partition Manager
  };
}
