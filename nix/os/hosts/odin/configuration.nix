{ config, ... }:

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
        ../../modules/swayosd.nix
        # ../../modules/stylix.nix
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
    ./variables-local.nix
    ./hardware-configuration.nix

    ../../modules/development.nix

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
    ../../modules/nautilus.nix
    ../../modules/flatpak.nix
    ../../modules/logitech.nix
    ../../modules/openrgb.nix
    ../../modules/fstrim.nix
    # ../../modules/printing.nix
    ../../modules/jottacloud.nix
    ../../modules/vivaldi.nix
    ../../modules/nh.nix
    ../../modules/wezterm.nix
    ../../modules/git.nix
    ../../modules/3d-printing.nix
    ../../modules/obs-studio.nix
    ../../modules/vial.nix
  ];

  sops = {
    # defaultSopsFile = "${config.configOptions.userHome}/.dotfiles/nix/os/secrets/secrets.yaml";
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "${config.configOptions.userHome}/.config/sops/age/keys.txt";

    secrets = {
      hello = { };
    };
  };

  networking = {
    nameservers = [
      "192.168.2.9" # TODO: Remove this after router is updated
      "9.9.9.9"
    ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

  home-manager.users.${config.configOptions.username} =
    { config
    , pkgs
    , ...
    }:
    {
      imports = [ ./variables-local.nix ];

      home = {
        packages = [
          # Utils
          pkgs.headsetcontrol # Set options for headsets

          # Tools
          # pkgs.blender

          # Gaming
          pkgs.heroic

          # Music / video
          pkgs.spotify
          pkgs.freetube
          pkgs.vlc

          # Chat
          pkgs.telegram-desktop
          pkgs.vesktop
          pkgs.discord

          pkgs.age
          pkgs.sops
        ];

        file = {
          ".face.icon".source = config.lib.file.mkOutOfStoreSymlink "${config.configOptions.userHome}/.dotfiles/sddm/.face.icon";
          ".config/niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "${config.configOptions.userHome}/.dotfiles/niri/config.kdl";

          ".icons/Banana".source = config.lib.file.mkOutOfStoreSymlink "${pkgs.banana-cursor}/share/icons/Banana";
          ".icons/Dracula".source = config.lib.file.mkOutOfStoreSymlink "${pkgs.dracula-icon-theme}/share/icons/Dracula";
        };

      };
    };
}
