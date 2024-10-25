{ config
, pkgs
, lib
, ...
}:

{

  services.udev.packages = [
    pkgs.vial
  ];

  home-manager.users.${config.configOptions.username} =
    { config, pkgs, ... }:
    {
      home = {
        packages = [
          pkgs.vial
        ];
      };
    };
}
