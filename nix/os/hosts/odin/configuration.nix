{ inputs
, config
, pkgs
, ...
}:
let
  secretspath = builtins.toString inputs.dotfiles-private-nonflake;
in
{
  boot.loader.grub.default = 1; # this should be 01-niri
  specialisation = {
    "01-niri".configuration = {
      environment.etc."specialisation".text = "01-niri";
      system.nixos.tags = [ "niri" ];

      imports = [
        ../../modules/niri.nix
        ../../modules/greetd.nix
        ../../modules/seahorse.nix
      ];
    };

    "02-plasma".configuration = {
      environment.etc."specialisation".text = "02-plasma";
      system.nixos.tags = [ "plasma" ];
      imports = [
        ../../modules/plasma.nix
        ../../modules/sddm.nix
      ];
    };
  };

  imports = [
    ./hardware-configuration.nix

    ../../modules/base.nix
    ../../modules/base_headfull.nix
    ../../modules/networking.nix
    ../../modules/virtualization.nix
    ../../modules/gpu-amd.nix
    ../../modules/users.nix
    ../../modules/keyd.nix
    ../../modules/gaming.nix
    ../../modules/grub.nix
    ../../modules/zsh.nix
    ../../modules/nautilus.nix
    ../../modules/flatpak.nix
    ../../modules/logitech.nix
    ../../modules/openrgb.nix
    ../../modules/fstrim.nix
    ../../modules/nh.nix
    ../../modules/qmk.nix
    ../../modules/sops.nix
  ];

  networking = {
    nameservers = [
      "192.168.2.9" # TODO: Remove this after router is updated
      "9.9.9.9"
    ];
  };

  sops = {
    secrets = {
      "ssh/config" = {
        sopsFile = "${secretspath}/sops/secrets/hosts/odin/odin.yaml";
        path = "${config.user-config.home}/.ssh/config";
        owner = config.users.users.${config.user-config.name}.name;
        group = config.users.users.${config.user-config.name}.group;
        mode = "0600";
      };
      "ssh/id_ed25519" = {
        sopsFile = "${secretspath}/sops/secrets/hosts/odin/odin.yaml";
        path = "${config.user-config.home}/.ssh/id_ed25519";
        owner = config.users.users.${config.user-config.name}.name;
        group = config.users.users.${config.user-config.name}.group;
        mode = "0600";
      };
      "ssh/id_ed25519.pub" = {
        sopsFile = "${secretspath}/sops/secrets/hosts/odin/odin.yaml";
        path = "${config.user-config.home}/.ssh/id_ed25519.pub";
        owner = config.users.users.${config.user-config.name}.name;
        group = config.users.users.${config.user-config.name}.group;
        mode = "0644";
      };
      "env/cloudflare" = {
        sopsFile = "${secretspath}/sops/secrets/hosts/heimdall/heimdall.yaml";
      };
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
