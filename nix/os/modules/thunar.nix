{ config, pkgs, lib, ... }:

{
  services = {
    gvfs.enable = true; # Mount, trash, and other functionalities
    tumbler.enable = true; # Thumbnail support
  };

  environment.systemPackages = [
    # pkgs.f3d
    pkgs.nufraw-thumbnailer
    pkgs.ffmpegthumbnailer
    pkgs.epub-thumbnailer
    pkgs.webp-pixbuf-loader
  ];

  programs = {
    thunar = {
      enable = true;
      plugins = [
        pkgs.xfce.thunar-archive-plugin
        pkgs.xfce.thunar-volman
      ];
    };
    xfconf.enable = true;
  };
}
