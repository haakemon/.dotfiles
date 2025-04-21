{ config, pkgs, lib, ... }:

{
  services.udev.packages = [ pkgs.swayosd ];

  home-manager.users.${config.user-config.name} = { config, pkgs, ... }: {
    services.swayosd = {
      enable = true;
    };
  };
}
