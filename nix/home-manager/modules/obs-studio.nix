{ config, pkgs, ... }:

{

  programs.obs-studio = {
    enable = true;
    plugins = [
      pkgs.obs-studio-plugins.wlrobs
      pkgs.obs-studio-plugins.obs-backgroundremoval
      pkgs.obs-studio-plugins.obs-pipewire-audio-capture
      pkgs.obs-studio-plugins.obs-mute-filter
      pkgs.obs-studio-plugins.obs-gradient-source
      pkgs.obs-studio-plugins.obs-composite-blur
      # pkgs.obs-studio-plugins.droidcam-obs # https://github.com/NixOS/nixpkgs/pull/382559
    ];
  };

}
