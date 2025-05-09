{ inputs, config, ... }:

{
  imports = [
    ./system-config.nix
    ../../user-options.nix
    ../../config-options.nix
  ];

  user-config = {
    name = "haakemon";
  };
}
