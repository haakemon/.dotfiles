{ config, pkgs, ... }:

{
  home-manager.users.${config.configOptions.username} =
    { config
    , pkgs
    , lib
    , ...
    }:

    {
      home = {
        packages = [
          # pkgs.bambu-studio
          # pkgs.plasticity
          pkgs.fstl
        ];
      };
    };
}
