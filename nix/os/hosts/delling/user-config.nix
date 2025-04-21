{ inputs, config, ... }:

{
  imports = [
    ./variables-local.nix
    ../../user-options.nix
  ];

  user-config = {
    name = config.configOptions.username;
  };
}
