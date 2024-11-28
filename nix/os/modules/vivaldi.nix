{ config, pkgs, lib, ... }:

{
  home-manager.users.${config.configOptions.username} = { config, pkgs, ... }: {
    home = {
      packages = [
        pkgs.vivaldi
      ];
    };
  };
}
