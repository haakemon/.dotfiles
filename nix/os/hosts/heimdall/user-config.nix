{ inputs, config, ... }:

{
  imports = [
    ./system-config.nix
    ../../config-options.nix
    ../../user-options.nix
  ];

  user-config = {
    name = "haakemon";
  };
}
