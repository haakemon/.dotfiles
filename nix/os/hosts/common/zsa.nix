{ config, pkgs, ... }:

{
  hardware.keyboard.zsa.enable = true;

  users.users.${config.configOptions.username} = {
    extraGroups = [
      "plugdev"
    ];
    packages = [
      pkgs.keymapp
    ];
  };
}
