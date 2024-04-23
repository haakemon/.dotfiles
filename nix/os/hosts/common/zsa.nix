{ config, pkgs, lib, ... }:

{
  hardware.keyboard.zsa.enable = true;

  users.users.${config.configOptions.username} = {
    extraGroups = [
      "plugdev"
    ];
    packages = lib.mkIf (!config.configOptions.headless) [
      pkgs.keymapp
    ];
  };
}
