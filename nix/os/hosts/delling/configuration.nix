{ inputs, config, pkgs, ... }:
let
  secretspath = builtins.toString inputs.sops-secrets;
  cfg = config;
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
    "03-cosmic".configuration = {
      environment.etc."specialisation".text = "03-cosmic";
      system.nixos.tags = [ "cosmic" ];
      imports = [
        ../../modules/cosmic.nix
      ];
    };
  };

  imports = [
    ./configuration-local.nix
    ./hardware-configuration.nix

    ../../config-options.nix
    ../../user-options.nix
    ../../system-options.nix

    inputs.nrk-hylla.nixosModules

    ../../modules/development.nix

    ../../modules/base.nix
    ../../modules/networking.nix
    ../../modules/virtualization.nix
    ../../modules/gpu-nvidia.nix
    ../../modules/users.nix
    ../../modules/keyd.nix
    ../../modules/grub.nix
    ../../modules/zsh.nix
    ../../modules/thunar.nix
    ../../modules/logitech.nix
    ../../modules/fstrim.nix
    ../../modules/printing.nix
    ../../modules/nautilus.nix
    ../../modules/browsers.nix
    ../../modules/nh.nix
    ../../modules/git.nix
    ../../modules/obs-studio.nix
    ../../modules/upower.nix
    ../../modules/qmk.nix
    ../../modules/keybase.nix
    ../../modules/sops.nix
  ];

  boot = {
    loader = {
      grub = {
        useOSProber = false;
        enableCryptodisk = true;
      };
    };
    initrd = {
      luks.devices."enc-pv" = {
        device = "/dev/disk/by-uuid/17b53833-98dc-4862-afa6-6bcfa36474ce";
        preLVM = true;
        allowDiscards = true;
      };
    };
  };

  programs.f5vpn = {
    enable = true;
    oesisUser = config.user-config.name;
  };

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
        sopsFile = "${secretspath}/secrets/hosts/delling/delling.yaml";
        path = "${config.user-config.home}/.ssh/id_ed25519";
        owner = config.users.users.${config.user-config.name}.name;
        group = config.users.users.${config.user-config.name}.group;
        mode = "0600";
      };
      "ssh/id_ed25519.pub" = {
        sopsFile = "${secretspath}/secrets/hosts/delling/delling.yaml";
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

  home-manager.users.${config.user-config.name} =
    { config
    , pkgs
    , ...
    }:
    {
      imports = [
        ../../user-options.nix
        ../../system-options.nix
      ];

      user-config = {
        name = cfg.user-config.name;
      };

      system-config = {
        hostname = cfg.system-config.hostname;
      };

      programs = {
        zsh = {
          initContent = ''
            #region initContent configuration.nix
            source "''${HOME}/work/configs/env.zsh"
            #endregion initContent configuration.nix
          '';
        };
      };

      systemd.user.services."logiops" = {
        Unit.Description = "Unofficial userland driver for logitech devices";
        Install.WantedBy = [ "graphical-session.target" ];
        Service = {
          ExecStart = "${pkgs.pkgs.logiops_0_2_3}/bin/logid --config ${config.user-config.home}/.dotfiles/logid/mx-master-3-for-mac.cfg";
          Restart = "on-failure";
          RestartSec = 10;
        };
      };

      programs = {
        hyprlock = {
          settings = {
            auth = {
              "fingerprint:enabled" = true;
            };
          };
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
          pkgs.dotnet-sdk_9
          pkgs.traefik

          # Chat
          pkgs.telegram-desktop
          pkgs.slack
        ];

        file = {
          ".config/niri/config.kdl".source =
            config.lib.file.mkOutOfStoreSymlink "${config.user-config.home}/.dotfiles/niri/config-delling.kdl";
        };
      };
    };
}
