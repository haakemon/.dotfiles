{ config, pkgs, lib, ... }:

{
  home-manager.users.${config.user-config.name} = { inputs, config, pkgs, ... }: {
    home = {
      packages = [
        inputs.zen-browser.packages."x86_64-linux".default
      ];
    };
  };
}
