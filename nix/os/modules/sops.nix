{ config, pkgs, ... }:

{
  sops = {
    # defaultSopsFile = "${config.configOptions.userHome}/.dotfiles/nix/os/secrets/secrets.yaml";
    defaultSopsFile = ../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/etc/secrets/sops/age/keys.txt";

    secrets = {
      hello = { };
    };
  };

  environment.systemPackages = [
    pkgs.age
    pkgs.sops
  ];

  system.activationScripts.sopsDirs = ''
    mkdir -p /etc/secrets/sops/age
  '';
}
