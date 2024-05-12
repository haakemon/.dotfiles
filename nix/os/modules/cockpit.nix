{ config, ... }:

{
  services.cockpit = {
    enable = true;
    settings = {
      WebService.Origins = "https://cockpit.${config.configOptions.acme.domain}";
    };
  };
}
