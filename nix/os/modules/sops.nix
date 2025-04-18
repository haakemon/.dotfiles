{ config, pkgs, inputs, ... }:
let
  secretspath = builtins.toString inputs.sops-secrets;
  keysFileLocation = "/etc/secrets/sops/age/keys.txt";
in
{

  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    defaultSopsFile = "${secretspath}/secrets/common.yaml";
    defaultSopsFormat = "yaml";
    age.keyFile = keysFileLocation;

    secrets = {
      "private_keys/ssh/id_ed25519--git" = {
        path = "${config.configOptions.userHome}/.ssh/id_ed25519--git";
        owner = config.users.users.${config.configOptions.username}.name;
        group = config.users.users.${config.configOptions.username}.group;
        mode = "0600";
      };
      "private_keys/ssh/id_ed25519--git.pub" = {
        path = "${config.configOptions.userHome}/.ssh/id_ed25519--git.pub";
        owner = config.users.users.${config.configOptions.username}.name;
        group = config.users.users.${config.configOptions.username}.group;
        mode = "0644";
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
