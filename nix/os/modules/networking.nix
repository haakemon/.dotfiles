{ config, ... }:

{
  networking = {
    hostName = "${config.configOptions.hostname}";
    networkmanager.enable = true;
    # hosts = {
    #   "127.0.0.1" = [	"local.dev" ];
    # };
  };

  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
    };
  };
}
