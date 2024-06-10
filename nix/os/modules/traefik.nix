{ config, ... }:

{
  services = {
    traefik = {
      enable = true;
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
            http.tls.certResolver = "letsencrypt";
            forwardedHeaders.trustedIps = [ "127.0.0.1" ];
          };
        };
        certificatesResolvers = {
          letsencrypt.acme = {
            email = "${config.configOptions.acme.email}";
            # caServer = "https://acme-staging-v02.api.letsencrypt.org/directory";
            storage = "/var/lib/traefik/cert.json";
            dnsChallenge = {
              provider = "cloudflare";
              # delayBeforeCheck = 0;
            };
          };
        };
      };

      dynamicConfigOptions = {
        tls = {
          stores.default = {
            defaultCertificate = {
              certFile = "/var/lib/acme/${config.configOptions.acme.domain}/cert.pem";
              keyFile = "/var/lib/acme/${config.configOptions.acme.domain}/key.pem";
            };
          };
          certificates = [
            {
              certFile = "/var/lib/acme/${config.configOptions.acme.domain}/cert.pem";
              keyFile = "/var/lib/acme/${config.configOptions.acme.domain}/key.pem";
              stores = "default";
            }
          ];
        };
      };


      # http = {
      #   services = {
      #     localhost3000.loadBalancer.servers = [{ url = "http://localhost:3000"; }];
      #   };

      #   routers = {
      #     localhost3000 = {
      #       rule = "Host(`localhost3000.${config.configOptions.acme.domain}`)";
      #       entryPoints = [ "websecure" ];
      #       service = "localhost3000";
      #       tls.certresolver = "letsencrypt";
      #     };
      #   };
      # };

    };
  };

  networking = {
    firewall = {
      allowedTCPPorts = [ 80 443 ];
    };
  };
}
