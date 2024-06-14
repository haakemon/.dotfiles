{ config, pkgs, ... }:

{
  imports =
    [
      ./variables-local.nix
      ./hardware-configuration.nix
      ../common/base.nix
      ../common/boot.nix
      ../common/networking.nix
      ../common/virtualization.nix
      ../common/keyd.nix
      ../common/users.nix

      ../../modules/zsa.nix
      ../../modules/wireguard.nix
      ../../modules/cockpit.nix
      ../../modules/ssh.nix
      ../../modules/traefik.nix
      ../../modules/adguard.nix
    ];

  services = {
    # fstrim = {
    #   enable = true;
    #   interval = "weekly";
    # };

    traefik.dynamicConfigOptions.http = {
      services = {
        homarr.loadBalancer.servers = [{ url = "http://127.0.0.1:7575"; }];
        cockpit.loadBalancer.servers = [{ url = "http://127.0.0.1:9090"; }];
        octoprint.loadBalancer.servers = [{ url = "http://192.168.2.10"; }];
        valetudo.loadBalancer.servers = [{ url = "http://192.168.2.11"; }];
        zigbee2mqtt.loadBalancer.servers = [{ url = "http://127.0.0.1:8089"; }];
        zwavejs2mqtt.loadBalancer.servers = [{ url = "http://127.0.0.1:8091"; }];
        hass.loadBalancer.servers = [{ url = "http://127.0.0.1:8123"; }];
        memories.loadBalancer.servers = [{ url = "http://127.0.0.1:2342"; }];
        teslamate.loadBalancer.servers = [{ url = "http://127.0.0.1:4000"; }];
        "teslamate-stats".loadBalancer.servers = [{ url = "http://127.0.0.1:4001"; }];
        adguard.loadBalancer.servers = [{ url = "http://127.0.0.1:3050"; }];
        status.loadBalancer.servers = [{ url = "http://127.0.0.1:3001"; }];
        tracks.loadBalancer.servers = [{ url = "http://127.0.0.1:3005"; }];
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

        octoprint = {
          rule = "Host(`octoprint.${config.configOptions.acme.domain}`)";
          entryPoints = [ "websecure" ];
          service = "octoprint";
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

        photoprism = {
          rule = "Host(`photoprism.${config.configOptions.acme.domain}`)";
          entryPoints = [ "websecure" ];
          service = "memories";
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

        tracks = {
          rule = "Host(`tracks.${config.configOptions.acme.domain}`)";
          entryPoints = [ "websecure" ];
          service = "tracks";
        };
      };
    };
  };

  # systemd.user.services.jotta = {
  #   wantedBy = [ "default.target" ];
  #   serviceConfig = {
  #     Type = "exec";
  #     ExecStart = "${pkgs.jotta-cli}/bin/jottad";
  #   };
  # };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
