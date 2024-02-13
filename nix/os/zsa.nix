{ config, username, ... }:

{
  hardware.keyboard.zsa.enable = true;

  users.users.${username} = {
    extraGroups = [
      "plugdev"
    ];
  };
}
