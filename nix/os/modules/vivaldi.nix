{ config, pkgs, lib, ... }:
let
  cus_vivaldi = pkgs.vivaldi.overrideAttrs
    (oldAttrs: {
      dontWrapQtApps = false;
      dontPatchELF = true;
      nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ pkgs.kdePackages.wrapQtAppsHook ];
    });
in
{
  home-manager.users.${config.configOptions.username} = { config, pkgs, ... }: {
    home = {
      packages = [
        # pkgs.vivaldi
        cus_vivaldi
      ];
    };
  };
}
