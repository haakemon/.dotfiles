{ config, pkgs, ... }:

{
  imports =
    [
      ./variables-local.nix
      ./hardware-configuration.nix
      ../common/base.nix
      ../common/boot.nix
      ../common/i18n.nix
      ../common/networking.nix
      ../common/virtualization.nix
      ../common/gpu-nvidia.nix
      ../common/keyd.nix
      ../common/sddm-theme
      ../common/zsa.nix
      ../common/users.nix
      ./configuration-local.nix
    ];

  hardware = {
    logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
    nvidia = {
      prime = {
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };

  services = {
    hardware.bolt.enable = true; # enable thunderbolt/dock capabilities

    ollama = {
      enable = true;
      acceleration = "cuda";
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
