{ config
, pkgs
, lib
, ...
}:

{

  hardware.keyboard.qmk.enable = true;

  home-manager.users.${config.user-config.name} =
    { config, pkgs, ... }:
    {
      home = {
        packages = [
          pkgs.qmk
        ];

        sessionVariables = {
          QMK_HOME = "${config.home.homeDirectory}/code/qmk_firmware";
        };
      };
    };
}
