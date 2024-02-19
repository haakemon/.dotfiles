{ ... }:
let
  inherit (import ./options.nix)
    hostname;
in
{
  networking = {
    hostName = "${hostname}";
    networkmanager.enable = true;
    nameservers = [
      "192.168.2.9"
      "9.9.9.9"
    ];
    # hosts = {
    #   "127.0.0.1" = [	"local.dev" ];
    # };
  };
}
