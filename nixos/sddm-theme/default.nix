
{ config, pkgs, ... }:

{
  services.xserver.displayManager.sddm.theme = "sugar-dark";

  environment.systemPackages = let themes = pkgs.callPackage ./sddm-themes.nix { }; in [
    themes.sddm-sugar-dark
    themes.sddm-vivid-dark
  ];
}
