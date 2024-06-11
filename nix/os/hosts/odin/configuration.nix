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
      ../common/gpu-amd.nix
      ../common/gaming.nix
      ../common/keyd.nix
      ../common/users.nix

      ../../modules/zsa.nix
      ../../modules/stylix.nix
      ../../modules/sddm.nix
      ../../modules/niri.nix
      #../../modules/plasma.nix
    ];

  # qt = {
  #   enable = true;
  #   style = "kvantum";
  #   # platformTheme = "qt5tc";
  # };

  stylix.image = ./transparent.png;

  #programs.seahorse.enable = true;

  services = {
    flatpak.enable = true;
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
