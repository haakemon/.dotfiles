{ config, pkgs, ... }:

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
    ./configuration-local.nix
    ./hardware-configuration.nix
    ./traefik.nix

    ../../modules/development.nix

    ../../modules/base.nix
    ../../modules/networking.nix
    ../../modules/virtualization.nix
    ../../modules/gpu-nvidia.nix
    ../../modules/users.nix
    ../../modules/keyd.nix
    ../../modules/zsa.nix
    ../../modules/acme.nix
    # ../../modules/traefik.nix # conflicts with the local variant - should be modularized
    ../../modules/grub.nix
    ../../modules/zsh.nix
    ../../modules/thunar.nix
    ../../modules/thunderbolt.nix
    ../../modules/logitech.nix
    ../../modules/fstrim.nix
    ../../modules/printing.nix
    ../../modules/nautilus.nix
    ../../modules/vivaldi.nix
    ../../modules/nh.nix
    ../../modules/wezterm.nix
    ../../modules/git.nix
    ../../modules/obs-studio.nix
    ../../modules/kanshi.nix
    ../../modules/zen-browser.nix
    ../../modules/upower.nix
    ../../modules/vial.nix
  ];

  hardware = {
    nvidia = {
      prime = {
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
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
      imports = [
        ./variables-local.nix
      ];

      programs = {
        zsh = {
          initExtra = ''
            #region default initExtra
            source "''${HOME}/work/configs/env.zsh"
            #endregion default initExtra
          '';
        };
      };

      systemd.user.services."logiops" = {
        Unit.Description = "Unofficial userland driver for logitech devices";
        Install.WantedBy = [ "graphical-session.target" ];
        Service = {
          ExecStart = "${pkgs.pkgs.logiops_0_2_3}/bin/logid --config ${config.configOptions.userHome}/.dotfiles/logid/mx-master-3-for-mac.cfg";
          Restart = "on-failure";
          RestartSec = 10;
        };
      };

      systemd.user.services."kanshi" = {
        Unit.Description = "Dynamic display configuration";
        Install.WantedBy = [ "graphical-session.target" ];
        Service = {
          ExecStart = "${pkgs.pkgs.kanshi}/bin/kanshi --config ${config.configOptions.userHome}/.dotfiles/kanshi/delling";
          Restart = "on-failure";
          RestartSec = 10;
        };
      };

      home = {
        packages = [
          # Utils
          pkgs.headsetcontrol # Set options for headsets
          pkgs.gcalcli

          # Music / video
          pkgs.freetube

          # Devtools
          pkgs.azure-cli
          pkgs.kubectl
          pkgs.kubelogin
          pkgs.kubectx
          pkgs.k9s
          pkgs.vault
          pkgs.dotnet-sdk_8

          # Chat
          pkgs.telegram-desktop
          pkgs.slack
        ];

        file = {
          ".face.icon".source = config.lib.file.mkOutOfStoreSymlink "${config.configOptions.userHome}/.dotfiles/sddm/.face.icon";
          ".config/niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "${config.configOptions.userHome}/.dotfiles/niri/config-delling.kdl";

          ".icons/Banana".source = config.lib.file.mkOutOfStoreSymlink "${pkgs.banana-cursor}/share/icons/Banana";
          ".icons/Dracula".source = config.lib.file.mkOutOfStoreSymlink "${pkgs.dracula-icon-theme}/share/icons/Dracula";
        };
      };
    };
}
