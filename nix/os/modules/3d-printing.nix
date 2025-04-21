{ config, pkgs, ... }:

{
  home-manager.users.${config.user-config.name} =
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
