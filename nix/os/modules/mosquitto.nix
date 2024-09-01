{ config, pkgs, lib, ... }:

{
  services = {
    mosquitto = {
      enable = true;

      listeners = [{
        settings.allow_anonymous = true;
        omitPasswordAuth = false;
        users.admin = {
          acl = [
            "readwrite #"
          ];
          passwordFile = "${config.configOptions.userHome}/secrets/mosquitto";
        };
      }];



    };
  };

  networking = {
    firewall = {
      allowedTCPPorts = [ 1883 ];
    };
  };
}
