{ config
, pkgs
, lib
, ...
}:

{

  hardware.keyboard.qmk.enable = true;

  home-manager.users.${config.configOptions.username} =
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
