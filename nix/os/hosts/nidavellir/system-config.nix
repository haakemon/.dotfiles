{ inputs, config, ... }:

{
  imports = [
    ../../system-options.nix
  ];

  system-config = {
    hostname = "nidavellir";
  };
}
