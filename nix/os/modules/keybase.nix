{ config, ... }:

{
  services.keybase.enable = true;

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
          ]
          ++ lib.optionals (!config.configOptions.headless) [
            pkgs.keybase-gui
          ];
      };
    };
}
