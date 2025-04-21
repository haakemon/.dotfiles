{ inputs, config, ... }:
let
  secretspath = builtins.toString inputs.sops-secrets;
in
{
  user-config = {
    name = config.configOptions.username;
  };

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
    ../../modules/grub.nix
    ../../modules/zsh.nix
    ../../modules/thunar.nix
    ../../modules/nautilus.nix
    ../../modules/flatpak.nix
    ../../modules/logitech.nix
    ../../modules/openrgb.nix
    ../../modules/fstrim.nix
    # ../../modules/printing.nix
    ../../modules/vivaldi.nix
    ../../modules/nh.nix
    ../../modules/git.nix
    ../../modules/3d-printing.nix
    ../../modules/obs-studio.nix
    ../../modules/qmk.nix
    ../../modules/zen-browser.nix
    ../../modules/keybase.nix
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
        sopsFile = "${secretspath}/secrets/hosts/odin/odin.yaml";
        path = "${config.configOptions.userHome}/.ssh/config";
        owner = config.users.users.${config.configOptions.username}.name;
        group = config.users.users.${config.configOptions.username}.group;
        mode = "0600";
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

  home-manager.users.${config.configOptions.username} =
    { config
    , pkgs
    , ...
    }:
    {
      imports = [ ./variables-local.nix ];

      systemd.user.timers."rclone-proton" = {
        Install.WantedBy = [ "timers.target" ];
        Timer = {
          OnCalendar = "*-*-* 13:00:00";
          Unit = "rclone-proton.service";
        };
      };

      systemd.user.services."rclone-proton" = {
        Unit = {
          Description = "Rclone sync to Proton Drive";
          After = "network-online.target";
        };
        Service = {
          Type = "exec";
          ExecStart = "${pkgs.rclone}/bin/rclone --rc sync ${config.configOptions.userHome}/ProtonDrive/ protondrive:computers/odin";
          StandardOutput = "journal";
          Restart = "no";
        };
      };

      home = {
        packages = [
          # Utils
          pkgs.headsetcontrol # Set options for headsets

          # Tools
          # pkgs.blender

          # Gaming
          pkgs.heroic

          # Music / video
          pkgs.freetube

          # Chat
          pkgs.telegram-desktop
          pkgs.vesktop
          pkgs.discord
        ];

        file = {
          ".config/niri/config.kdl".source =
            config.lib.file.mkOutOfStoreSymlink "${config.configOptions.userHome}/.dotfiles/niri/config.kdl";
        };
      };
    };
}
