{ config, pkgs, lib, ... }:

{
  services.udev.packages = [ pkgs.swayosd ];

  home-manager.users.${config.configOptions.username} = { config, pkgs, ... }: {
    services.swayosd = {
      enable = true;
    };
  };
}
