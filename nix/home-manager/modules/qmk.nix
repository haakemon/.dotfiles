{ config
, pkgs
, ...
}:

{
  home = {
    packages = [
      pkgs.qmk
    ];

    sessionVariables = {
      QMK_HOME = "${config.home.homeDirectory}/code/qmk_firmware";
    };
  };
}
