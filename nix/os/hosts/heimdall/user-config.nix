{ inputs, config, ... }:

{
  imports = [
    ./variables-local.nix
    ./system-config.nix
    ../../config-options.nix
    ../../user-options.nix
  ];

  user-config = {
    name = "haakemon";
  };
}
