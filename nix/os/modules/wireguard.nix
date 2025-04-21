{ config, pkgs, ... }:

{
  networking = {
    nat = {
      enable = true;
      externalInterface = "enp88s0";
      internalInterfaces = [ "wg0" ];
    };
    wireguard = {
      enable = true;
      interfaces.wg0 = {
        ips = [ "10.100.0.1/24" ];
        listenPort = config.configOptions.wireguardPort;

        postSetup = ''
          ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o enp88s0 -j MASQUERADE
        '';

        postShutdown = ''
          ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o enp88s0 -j MASQUERADE
        '';

        privateKeyFile = "${config.user-config.home}/data/wireguard/keys/server/private";

        peers = [
          {
            name = "haakemob";
            publicKey = "cgM7ZabyqOrGOkQ1GvIlCNQRNszLKVfS3xQcrdX8cSE=";
            presharedKeyFile = "${config.user-config.home}/data/wireguard/keys/peers/haakemob.psk";
            allowedIPs = [ "10.100.0.2/32" ];
          }
        ];
      };
    };
    firewall = {
      allowedUDPPorts = [ config.configOptions.wireguardPort ];
    };
  };
}
