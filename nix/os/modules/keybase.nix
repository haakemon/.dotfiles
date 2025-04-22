{ config, ... }:

{
  services.keybase.enable = true;
  services.kbfs.enable = true;

  home-manager.users.${config.user-config.name} =
    { inputs
    , config
    , pkgs
    , lib
    , ...
    }:
    {
      home = {
        packages =
          [
            pkgs.keybase
            pkgs.kbfs
          ]
          ++ lib.optionals (!config.system-config.headless) [
            pkgs.keybase-gui
          ];
      };
    };
}
