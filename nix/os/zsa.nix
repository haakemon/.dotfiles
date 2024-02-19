{ ... }:
let
  inherit (import ./options.nix)
    username;
in
{
  hardware.keyboard.zsa.enable = true;

  users.users.${username} = {
    extraGroups = [
      "plugdev"
    ];
  };
}
