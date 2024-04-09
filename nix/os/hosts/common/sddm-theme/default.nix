{ config, pkgs, ... }:

{
  # services.xserver.displayManager.sddm.theme = "sugar-dark"; # not compatible with qt6

  environment.systemPackages = let themes = pkgs.callPackage ./sddm-themes.nix { }; in [
    themes.sddm-sugar-dark
    themes.sddm-vivid-dark
  ];
}
