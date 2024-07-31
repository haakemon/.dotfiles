{ config, pkgs, ... }:

{
  boot.loader.grub.default = 1; # this should be 01-niri
  specialisation = {
    "01-niri".configuration = {
      system.nixos.tags = [ "niri" ];
      imports =
        [
          ../../modules/niri.nix
          ../../modules/greetd.nix
          ../../modules/stylix.nix
        ];
    };

    "02-plasma".configuration = {
      system.nixos.tags = [ "plasma" ];
      imports =
        [
          ../../modules/plasma.nix
          ../../modules/sddm.nix
        ];
    };
  };

  imports =
    [
      ./variables-local.nix
      ./hardware-configuration.nix
      ../../modules/base.nix
      ../../modules/networking.nix
      ../../modules/virtualization.nix
      ../../modules/gpu-amd.nix
      ../../modules/users.nix

      ../../modules/keyd.nix
      ../../modules/gaming.nix
      ../../modules/zsa.nix
      ../../modules/grub.nix
      ../../modules/zsh.nix
      ../../modules/thunar.nix
      ../../modules/flatpak.nix
    ];

  # qt = {
  #   enable = true;
  #   style = "kvantum";
  #   # platformTheme = "qt5tc";
  # };

  programs.plotinus.enable = true;
  gtk.iconCache.enable = true;

  stylix.image = ./transparent.png;

  #programs.seahorse.enable = true;

  services = {
    hardware.openrgb = {
      enable = true;
      motherboard = "amd";
    };

    # fstrim = {
    #   enable = true;
    #   interval = "weekly";
    # };
  };

  hardware = {
    # spacenavd.enable = true; # 3D mouse support, not working?
    sane.enable = true; # Scanning
    logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
  };

  networking = {
    nameservers = [
      "192.168.2.9" # TODO: Remove this after router is updated
      "9.9.9.9"
    ];
  };

  systemd.user.services.jotta = {
    wantedBy = [ "default.target" ];
    serviceConfig = {
      Type = "exec";
      ExecStart = "${pkgs.jotta-cli}/bin/jottad";
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
