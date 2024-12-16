{ config
, pkgs
, lib
, ...
}:

{

  hardware.keyboard.qmk.enable = true;

  services.udev.packages = [
    pkgs.vial
  ];

  home-manager.users.${config.configOptions.username} =
    { config, pkgs, ... }:
    {
      home = {
        packages = [
          pkgs.vial
          pkgs.qmk
        ];

        sessionVariables = {
          QMK_HOME = "${config.home.homeDirectory}/code/qmk_firmware";
        };
      };
    };
}
