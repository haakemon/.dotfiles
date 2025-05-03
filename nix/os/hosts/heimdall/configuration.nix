{ inputs
, config
, pkgs
, lib
, ...
}:
let
  secretspath = builtins.toString inputs.sops-secrets;
in
{
  specialisation = {
    "02-plasma".configuration = {
      environment.etc."specialisation".text = "02-plasma";
      system.nixos.tags = [ "plasma" ];
      imports = [
        ../../modules/plasma.nix
        ../../modules/sddm.nix
        ../../modules/browsers.nix
        ../../modules/development.nix
      ];

      services = {
        xserver = {
          enable = true;
          xkb.layout = "no";
        };
        gvfs.enable = true; # Mount, trash, and other functionalities
      };
    };
  };

  imports = [
    ./user-config.nix
    ./hardware-configuration.nix

    ../../modules/base.nix
    ../../modules/networking.nix
    ../../modules/virtualization.nix
    ../../modules/users.nix
    ../../modules/keyd.nix
    ../../modules/wireguard.nix
    ../../modules/cockpit.nix
    ../../modules/ssh.nix
    ../../modules/adguard.nix
    ../../modules/grub.nix
    ../../modules/zsh.nix
    ../../modules/fstrim.nix
    ../../modules/nh.nix
    ../../modules/git.nix
    ../../modules/keybase.nix
    ../../modules/sops.nix
  ];

  services = {
    cockpit = {
      enable = true;

      allowed-origins = [
        "https://cockpit.${config.configOptions.acme.domain}"
      ];
    };
    hardware.bolt.enable = true;

    traefik = {
      enable = true;
      environmentFiles = [
        config.sops.secrets."env/cloudflare".path
      ];
      staticConfigOptions = {
        api = {
          dashboard = true;
        };
        global = {
          checkNewVersion = false;
          sendAnonymousUsage = false;
        };
        entryPoints = {
          websecure = {
            address = ":443";
            http.tls = {
              certResolver = "letsencrypt";
              domains = [
                {
                  main = "${config.configOptions.acme.domain}";
                  sans = [
                    "*.${config.configOptions.acme.domain}"
                  ];
                }
              ];
            };
            forwardedHeaders.trustedIps = [ "127.0.0.1" ];
          };
        };
        certificatesResolvers = {
          letsencrypt.acme = {
            # caServer = "https://acme-staging-v02.api.letsencrypt.org/directory";
            storage = "/var/lib/traefik/cert.json";
            dnsChallenge = {
              provider = "cloudflare";
            };
          };
        };
      };
      dynamicConfigOptions.http = {
        services = {
          valetudo.loadBalancer.servers = [{ url = "http://192.168.2.11"; }];
          homarr.loadBalancer.servers = [{ url = "http://127.0.0.1:7575"; }];
          cockpit.loadBalancer.servers = [{ url = "http://127.0.0.1:9090"; }];
          zigbee2mqtt.loadBalancer.servers = [{ url = "http://127.0.0.1:8089"; }];
          zwavejs2mqtt.loadBalancer.servers = [{ url = "http://127.0.0.1:8091"; }];
          hass.loadBalancer.servers = [{ url = "http://127.0.0.1:8123"; }];
          memories.loadBalancer.servers = [{ url = "http://127.0.0.1:2342"; }];
          teslamate.loadBalancer.servers = [{ url = "http://127.0.0.1:4000"; }];
          "teslamate-stats".loadBalancer.servers = [{ url = "http://127.0.0.1:4001"; }];
          adguard.loadBalancer.servers = [{ url = "http://127.0.0.1:3050"; }];
          status.loadBalancer.servers = [{ url = "http://127.0.0.1:3001"; }];
          scrutiny.loadBalancer.servers = [{ url = "http://127.0.0.1:8999"; }];
        };

        routers = {
          homarr = {
            rule = "Host(`${config.configOptions.acme.domain}`)";
            entryPoints = [ "websecure" ];
            service = "homarr";
          };

          traefik = {
            rule = "Host(`traefik.${config.configOptions.acme.domain}`)";
            entryPoints = [ "websecure" ];
            service = "api@internal";
          };

          cockpit = {
            rule = "Host(`cockpit.${config.configOptions.acme.domain}`)";
            entryPoints = [ "websecure" ];
            service = "cockpit";
          };

          valetudo = {
            rule = "Host(`valetudo.${config.configOptions.acme.domain}`)";
            entryPoints = [ "websecure" ];
            service = "valetudo";
          };

          zigbee2mqtt = {
            rule = "Host(`zigbee2mqtt.${config.configOptions.acme.domain}`)";
            entryPoints = [ "websecure" ];
            service = "zigbee2mqtt";
          };

          zwavejs2mqtt = {
            rule = "Host(`zwavejs2mqtt.${config.configOptions.acme.domain}`)";
            entryPoints = [ "websecure" ];
            service = "zwavejs2mqtt";
          };

          hass = {
            rule = "Host(`hass.${config.configOptions.acme.domain}`)";
            entryPoints = [ "websecure" ];
            service = "hass";
          };

          memories = {
            rule = "Host(`memories.${config.configOptions.acme.domain}`)";
            entryPoints = [ "websecure" ];
            service = "memories";
          };

          teslamate = {
            rule = "Host(`tesla.${config.configOptions.acme.domain}`)";
            entryPoints = [ "websecure" ];
            service = "teslamate";
          };

          "teslamate-stats" = {
            rule = "Host(`tesla-stats.${config.configOptions.acme.domain}`)";
            entryPoints = [ "websecure" ];
            service = "teslamate-stats";
          };

          adguard = {
            rule = "Host(`adguard.${config.configOptions.acme.domain}`)";
            entryPoints = [ "websecure" ];
            service = "adguard";
          };

          status = {
            rule = "Host(`status.${config.configOptions.acme.domain}`)";
            entryPoints = [ "websecure" ];
            service = "status";
          };
        };
      };
    };

    mosquitto = {
      enable = true;
      listeners = [
        {
          settings.allow_anonymous = true;
          omitPasswordAuth = false;
          users.admin = {
            acl = [
              "readwrite #"
            ];
            passwordFile = config.sops.secrets."pwd/mosquitto".path;
          };
        }
      ];
    };
  };

  networking = {
    firewall = {
      allowedTCPPorts = [
        1883 # mosquitto
        443 # traefik
      ];
    };
  };

  sops = {
    secrets = {
      "ssh/authorized_keys" = {
        sopsFile = "${secretspath}/secrets/hosts/heimdall/heimdall.yaml";
        path = "${config.user-config.home}/.ssh/authorized_keys";
        owner = config.users.users.${config.user-config.name}.name;
        group = config.users.users.${config.user-config.name}.group;
        mode = "0640";
      };
      "ssh/id_ed25519" = {
        sopsFile = "${secretspath}/secrets/hosts/heimdall/heimdall.yaml";
        path = "${config.user-config.home}/.ssh/id_ed25519";
        owner = config.users.users.${config.user-config.name}.name;
        group = config.users.users.${config.user-config.name}.group;
        mode = "0600";
      };
      "ssh/id_ed25519.pub" = {
        sopsFile = "${secretspath}/secrets/hosts/heimdall/heimdall.yaml";
        path = "${config.user-config.home}/.ssh/id_ed25519.pub";
        owner = config.users.users.${config.user-config.name}.name;
        group = config.users.users.${config.user-config.name}.group;
        mode = "0644";
      };
      "env/cloudflare" = {
        sopsFile = "${secretspath}/secrets/hosts/heimdall/heimdall.yaml";
      };
      "pwd/mosquitto" = {
        sopsFile = "${secretspath}/secrets/hosts/heimdall/heimdall.yaml";
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
    { config, pkgs, ... }:
    {

      imports = [
        ./user-config.nix
      ];

      systemd.user.timers."rclone-proton-immich" = {
        Install.WantedBy = [ "timers.target" ];
        Timer = {
          OnCalendar = "Mon 09:00:00";
          Unit = "rclone-proton-immich.service";
        };
      };

      systemd.user.services."rclone-proton-immich" = {
        Unit = {
          Description = "Rclone sync immich library to Proton Drive";
          After = "network-online.target";
        };
        Service = {
          Type = "exec";
          ExecStart = "${pkgs.rclone}/bin/rclone --rc sync ${config.user-config.home}/data/immich/files/ protondrive:computers/heimdall/immich";
          StandardOutput = "journal";
          Restart = "no";
        };
      };

    };
}
