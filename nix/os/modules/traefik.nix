{ config, ... }:

{
  security.acme = {
    acceptTerms = true;
    preliminarySelfsigned = false;
    defaults.email = "${config.configOptions.acme.email}";
    certs."${config.configOptions.acme.domain}" = {
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      credentialsFile = "${config.configOptions.userHome}/secrets/cloudflare";
      dnsPropagationCheck = true;
      domain = "${config.configOptions.acme.domain}";
      extraDomainNames = [ "*.${config.configOptions.acme.domain}" ];
    };
  };

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
          web = {
            address = ":80";
            http.redirections.entryPoint = {
              to = "websecure";
              scheme = "https";
              permanent = true;
            };
          };
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
    };
  };

  networking = {
    firewall = {
      allowedTCPPorts = [ 80 443 ];
    };
  };
}
