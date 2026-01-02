{ config
, pkgs
, ...
}:

{
  home = {
    packages = [
      # pkgs.qmk # https://github.com/NixOS/nixpkgs/pull/475990
    ];

    sessionVariables = {
      QMK_HOME = "${config.home.homeDirectory}/code/qmk_firmware";
    };
  };
}
