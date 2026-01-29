{ inputs
, config
, pkgs
, lib
, ...
}:
let
  secretspath = builtins.toString inputs.dotfiles-private-nonflake;
in
{
  specialisation = {
    "02-plasma".configuration = {
      environment.etc."specialisation".text = "02-plasma";
      system.nixos.tags = [ "plasma" ];
      imports = [
        ../../modules/plasma.nix
        ../../modules/sddm.nix
        ../../modules/base_headfull.nix
      ];
    };
  };

  imports = [
    ./hardware-configuration.nix

    ../../modules/base.nix
    ../../modules/networking.nix
    ../../modules/virtualization.nix
    ../../modules/users.nix
    ../../modules/keyd.nix
    ../../modules/ssh.nix
    ../../modules/grub.nix
    ../../modules/zsh.nix
    ../../modules/nh.nix
    ../../modules/sops.nix
  ];

  services = {
    cockpit = {
      enable = true;

      allowed-origins = [
        "https://cockpit.${config.system-config.acme.domain}"
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
                  main = "${config.system-config.acme.domain}";
                  sans = [
                    "*.${config.system-config.acme.domain}"
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
          money.loadBalancer.servers = [{ url = "http://127.0.0.1:8182"; }];
          food.loadBalancer.servers = [{ url = "http://127.0.0.1:8255"; }];
          music.loadBalancer.servers = [{ url = "http://127.0.0.1:8095"; }];
        };

        routers = {
          homarr = {
            rule = "Host(`${config.system-config.acme.domain}`)";
            entryPoints = [ "websecure" ];
            service = "homarr";
          };

          traefik = {
            rule = "Host(`traefik.${config.system-config.acme.domain}`)";
            entryPoints = [ "websecure" ];
            service = "api@internal";
          };

          cockpit = {
            rule = "Host(`cockpit.${config.system-config.acme.domain}`)";
            entryPoints = [ "websecure" ];
            service = "cockpit";
          };

          valetudo = {
            rule = "Host(`valetudo.${config.system-config.acme.domain}`)";
            entryPoints = [ "websecure" ];
            service = "valetudo";
          };

          zigbee2mqtt = {
            rule = "Host(`zigbee2mqtt.${config.system-config.acme.domain}`)";
            entryPoints = [ "websecure" ];
            service = "zigbee2mqtt";
          };

          zwavejs2mqtt = {
            rule = "Host(`zwavejs2mqtt.${config.system-config.acme.domain}`)";
            entryPoints = [ "websecure" ];
            service = "zwavejs2mqtt";
          };

          hass = {
            rule = "Host(`hass.${config.system-config.acme.domain}`)";
            entryPoints = [ "websecure" ];
            service = "hass";
          };

          music = {
            rule = "Host(`music.${config.system-config.acme.domain}`)";
            entryPoints = [ "websecure" ];
            service = "music";
          };

          memories = {
            rule = "Host(`memories.${config.system-config.acme.domain}`)";
            entryPoints = [ "websecure" ];
            service = "memories";
          };

          teslamate = {
            rule = "Host(`tesla.${config.system-config.acme.domain}`)";
            entryPoints = [ "websecure" ];
            service = "teslamate";
          };

          "teslamate-stats" = {
            rule = "Host(`tesla-stats.${config.system-config.acme.domain}`)";
            entryPoints = [ "websecure" ];
            service = "teslamate-stats";
          };

          adguard = {
            rule = "Host(`adguard.${config.system-config.acme.domain}`)";
            entryPoints = [ "websecure" ];
            service = "adguard";
          };

          status = {
            rule = "Host(`status.${config.system-config.acme.domain}`)";
            entryPoints = [ "websecure" ];
            service = "status";
          };

          scrutiny = {
            rule = "Host(`scrutiny.${config.system-config.acme.domain}`)";
            entryPoints = [ "websecure" ];
            service = "scrutiny";
          };

          money = {
            rule = "Host(`money.${config.system-config.acme.domain}`)";
            entryPoints = [ "websecure" ];
            service = "money";
          };

          food = {
            rule = "Host(`food.${config.system-config.acme.domain}`)";
            entryPoints = [ "websecure" ];
            service = "food";
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

    adguardhome = {
      enable = true;
      mutableSettings = false;
      port = 3050;

      # https://github.com/AdguardTeam/AdGuardHome/wiki/Configuration#configuration-file
      settings = {
        dhcp.enabled = false;
        dns = {
          bind_host = "0.0.0.0";
          bind_port = "53";
          enable_dnssec = true;
          bootstrap_dns = [
            "9.9.9.9"
          ];
          upstream_dns = [
            "9.9.9.9"
          ];
          fallback_dns = [
            "1.1.1.1"
          ];
        };

        filters = [
          {
            enabled = true;
            name = "AdGuard DNS filter";
            url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt";
            id = 1;
          }
          {
            enabled = true;
            name = "AdAway Default Blocklist";
            url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_2.txt";
            id = 2;
          }
          {
            enabled = true;
            name = "Phishing URL Blocklist (AdGuard Home)";
            url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_30.txt";
            id = 3;
          }
          {
            enabled = true;
            name = "Phishing Army";
            url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_18.txt";
            id = 4;
          }
          {
            enabled = true;
            name = "Malicious URL Blocklist (URLHaus)";
            url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_11.txt";
            id = 5;
          }
          {
            enabled = true;
            name = "uBlock filters – Badware risks";
            url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_50.txt";
            id = 6;
          }
          {
            enabled = true;
            name = "The Big List of Hacked Malware Web Sites";
            url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_9.txt";
            id = 7;
          }
        ];
      };
    };
  };

  networking = {
    firewall = {
      enable = true;
      trustedInterfaces = [
        "enp88s0"
        "wg0"
      ];
    };

    nat = {
      enable = true;
      externalInterface = "enp88s0";
      internalInterfaces = [ "wg0" ];
    };

    wireguard = {
      enable = true;
      interfaces.wg0 = {
        ips = [ "10.100.0.1/24" ];
        listenPort = 51886;

        postSetup = ''
          ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o enp88s0 -j MASQUERADE
        '';

        postShutdown = ''
          ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o enp88s0 -j MASQUERADE
        '';

        privateKeyFile = "${config.user-config.home}/data/wireguard/keys/server/private";

        peers = [
          {
            name = "haakemob";
            publicKey = "cgM7ZabyqOrGOkQ1GvIlCNQRNszLKVfS3xQcrdX8cSE=";
            presharedKeyFile = "${config.user-config.home}/data/wireguard/keys/peers/haakemob.psk";
            allowedIPs = [ "10.100.0.2/32" ];
          }
        ];
      };
    };
  };

  sops = {
    secrets = {
      "ssh/authorized_keys" = {
        sopsFile = "${secretspath}/sops/secrets/hosts/heimdall/heimdall.yaml";
        path = "${config.user-config.home}/.ssh/authorized_keys";
        owner = config.users.users.${config.user-config.name}.name;
        group = config.users.users.${config.user-config.name}.group;
        mode = "0640";
      };
      "ssh/id_ed25519" = {
        sopsFile = "${secretspath}/sops/secrets/hosts/heimdall/heimdall.yaml";
        path = "${config.user-config.home}/.ssh/id_ed25519";
        owner = config.users.users.${config.user-config.name}.name;
        group = config.users.users.${config.user-config.name}.group;
        mode = "0600";
      };
      "ssh/id_ed25519.pub" = {
        sopsFile = "${secretspath}/sops/secrets/hosts/heimdall/heimdall.yaml";
        path = "${config.user-config.home}/.ssh/id_ed25519.pub";
        owner = config.users.users.${config.user-config.name}.name;
        group = config.users.users.${config.user-config.name}.group;
        mode = "0644";
      };
      "env/cloudflare" = {
        sopsFile = "${secretspath}/sops/secrets/hosts/heimdall/heimdall.yaml";
      };
      "pwd/mosquitto" = {
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
