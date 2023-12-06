{ hostname, ... }:

{
  networking = {
    hostName = "${hostname}";
    networkmanager.enable = true;
    nameservers = [
      "192.168.2.9"
      "9.9.9.9"
    ];
  };
}
