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
  users.users.${config.configOptions.username} = {
    packages = [
      # pkgs.vivaldi
      cus_vivaldi
    ];
  };
}
