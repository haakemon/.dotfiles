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
      "ssh/allowed_signers" = {
        path = "${config.user-config.home}/.ssh/allowed_signers";
        owner = config.users.users.${config.user-config.name}.name;
        group = config.users.users.${config.user-config.name}.group;
        mode = "0600";
      };
      "ssh/id_ed25519--git" = {
        path = "${config.user-config.home}/.ssh/id_ed25519--git";
        owner = config.users.users.${config.user-config.name}.name;
        group = config.users.users.${config.user-config.name}.group;
        mode = "0600";
      };
      "ssh/id_ed25519--git.pub" = {
        path = "${config.user-config.home}/.ssh/id_ed25519--git.pub";
        owner = config.users.users.${config.user-config.name}.name;
        group = config.users.users.${config.user-config.name}.group;
        mode = "0644";
      };
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
