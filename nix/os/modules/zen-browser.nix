{ config, pkgs, lib, ... }:

{
  home-manager.users.${config.user-config.name} = { inputs, config, pkgs, ... }: {
    home = {
      packages = [
        pkgs.zen-browser
      ];
    };
  };
}
