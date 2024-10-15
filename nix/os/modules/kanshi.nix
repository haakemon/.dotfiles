{ config, pkgs, lib, ... }:

{
  users.users.${config.configOptions.username} = {
    packages = [
      pkgs.kanshi
    ];
  };
}
