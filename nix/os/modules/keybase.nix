{ config, ... }:

{
  services.keybase.enable = true;
  services.kbfs.enable = true;

  home-manager.users.${config.configOptions.username} =
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
          ++ lib.optionals (!config.configOptions.headless) [
            pkgs.keybase-gui
          ];
      };
    };
}
