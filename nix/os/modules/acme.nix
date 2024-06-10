{ config, ... }:

{
  security.acme = {
    acceptTerms = true;
    preliminarySelfsigned = false;
    defaults.email = "${config.configOptions.acme.email}";
    certs."${config.configOptions.acme.domain}" = {
      dnsProvider = "${config.configOptions.acme.provider}";
      dnsResolver = "1.1.1.1:53";
      credentialsFile = "${config.configOptions.acme.credentialsFile}";
      dnsPropagationCheck = true;
      domain = "${config.configOptions.acme.domain}";
      extraDomainNames = [ "*.${config.configOptions.acme.domain}" ];
      group = "traefik";
    };
  };
}
