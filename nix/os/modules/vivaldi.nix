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

    xdg.desktopEntries = {
      vivaldi = {
        name = "Vivaldi";
        genericName = "";
        exec = "${cus_vivaldi}/bin/vivaldi";
        terminal = false;
        categories = [ "Application" "Network" "WebBrowser" ];
        mimeType = [ "text/html" "text/xml" ];
        icon = "${cus_vivaldi}/opt/vivaldi/product_logo_256.png";
        type = "Application";
      };
    };
  };
}
