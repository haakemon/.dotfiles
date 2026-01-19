{ inputs
, config
, pkgs
, ...
}:
let
  secretspath = builtins.toString inputs.dotfiles-private-nonflake;
  cfg = config;
in
{
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

    "03-gnome".configuration = {
      environment.etc."specialisation".text = "03-gnome";
      system.nixos.tags = [ "gnome" ];
      imports = [
        ../../modules/gnome.nix
      ];
    };
  };

  imports = [
    # ./configuration-local.nix
    ./hardware-configuration.nix
    ./disk-config.nix
    ./bind-mounts.nix

    inputs.nrk-hylla.nixosModules

    ../../modules/base.nix
    ../../modules/base_headfull.nix
    ../../modules/networking.nix
    ../../modules/virtualization.nix
    ../../modules/gpu-nvidia.nix
    ../../modules/users.nix
    ../../modules/keyd.nix
    ../../modules/grub.nix
    ../../modules/zsh.nix
    ../../modules/logitech.nix
    ../../modules/printing.nix
    ../../modules/nautilus.nix
    ../../modules/nh.nix
    ../../modules/sops.nix
  ];

  boot = {
    loader = {
      grub = {
        enableCryptodisk = true;
        default = 1; # this will be 01-niri
      };
    };
  };

  # programs.f5vpn = {
  #   enable = true;
  #   oesisUser = config.user-config.name;
  # };

  hardware = {
    nvidia = {
      prime = {
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };

  services = {
    hardware.bolt.enable = true;
    fprintd = {
      # sudo fprintd-enroll <username>
      enable = true;
    };
  };

  security.wrappers.traefik = {
    owner = "root";
    group = "root";
    capabilities = "cap_net_bind_service=+ep";
    source = "${pkgs.traefik}/bin/traefik";
  };

  sops = {
    secrets = {
      "ssh/id_ed25519" = {
        sopsFile = "${secretspath}/sops/secrets/hosts/delling/delling.yaml";
        path = "${config.user-config.home}/.ssh/id_ed25519";
        owner = config.users.users.${config.user-config.name}.name;
        group = config.users.users.${config.user-config.name}.group;
        mode = "0600";
      };
      "ssh/id_ed25519.pub" = {
        sopsFile = "${secretspath}/sops/secrets/hosts/delling/delling.yaml";
        path = "${config.user-config.home}/.ssh/id_ed25519.pub";
        owner = config.users.users.${config.user-config.name}.name;
        group = config.users.users.${config.user-config.name}.group;
        mode = "0644";
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
