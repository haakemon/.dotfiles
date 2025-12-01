{ config, ... }:

{
  networking = {
    hostName = "${config.system-config.hostname}";
    networkmanager.enable = true;
    hosts = {
      # "127.0.0.1" = [ "local.dev" ];
      "192.168.1.149" = [ "public.haakemon.io" ];
    };
  };

  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
    };
  };
}
