{ inputs, config, ... }:

{
  imports = [
    ./system-config.nix
    ../../user-options.nix
  ];

  user-config = {
    name = "haakemon";
  };
}
