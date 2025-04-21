{ config, pkgs, lib, ... }:

{
  home-manager.users.${config.user-config.name} = { config, pkgs, ... }: {
    home = {
      packages = [
        pkgs.vivaldi
      ];
    };
  };
}
