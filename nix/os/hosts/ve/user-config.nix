{ inputs, config, ... }:

{
  imports = [
    ../../config-options.nix
    ../../user-options.nix
  ];

  user-config = {
    home = "/data/data/com.termux.nix/files/home";
  };
}
