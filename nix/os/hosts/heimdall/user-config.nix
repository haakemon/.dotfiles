{ inputs, config, ... }:

{
  imports = [
    ./variables-local.nix
    ./system-config.nix
    ../../user-options.nix
  ];

  user-config = {
    name = "haakemon";
  };
}
