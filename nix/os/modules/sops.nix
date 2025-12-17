{ config, pkgs, inputs, ... }:
let
  secretspath = builtins.toString inputs.dotfiles-private-nonflake;
  keysFileLocation = "/etc/secrets/sops/age/keys.txt";
in
{

  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    defaultSopsFile = "${secretspath}/sops/secrets/common.yaml";
    defaultSopsFormat = "yaml";
    age.keyFile = keysFileLocation;

    secrets = {
      "nix/accessTokens" = {
        group = config.users.users.${config.user-config.name}.group;
        mode = "0440";
      };
    };
  };

  environment.systemPackages = [
    pkgs.age
    pkgs.sops
  ];

  system.activationScripts.sopsDirs = ''
    mkdir -p /etc/secrets/sops/age
  '';

  environment.variables.SOPS_AGE_KEY_FILE = keysFileLocation;
}
