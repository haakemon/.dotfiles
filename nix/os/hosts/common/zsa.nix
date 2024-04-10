{ config, pkgs, lib, ... }:

{
  hardware.keyboard.zsa.enable = true;

  users.users.${config.configOptions.username} = {
    extraGroups = [
      "plugdev"
    ];
    packages = [
    ] ++ lib.optionals (!config.configOptions.headless) [
      pkgs.keymapp
    ];
  };
}
