{ config, ... }:
let
  dnsPort = 53;
in
{
  services = {
    adguardhome = {
      enable = true;
      mutableSettings = false;
      port = 3050;

      # https://github.com/AdguardTeam/AdGuardHome/wiki/Configuration#configuration-file
      settings = {
        dhcp.enabled = false;
        dns = {
          bind_host = "0.0.0.0";
          bind_port = dnsPort;
          enable_dnssec = true;
          bootstrap_dns = [
            "9.9.9.9"
          ];
          upstream_dns = [
            "9.9.9.9"
          ];
          fallback_dns = [
            "1.1.1.1"
          ];
        };

        filters = [
          {
            enabled = true;
            name = "AdGuard DNS filter";
            url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt";
            id = 1;
          }
          {
            enabled = true;
            name = "AdAway Default Blocklist";
            url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_2.txt";
            id = 2;
          }
          {
            enabled = true;
            name = "Phishing URL Blocklist (AdGuard Home)";
            url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_30.txt";
            id = 3;
          }
          {
            enabled = true;
            name = "Phishing Army";
            url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_18.txt";
            id = 4;
          }
          {
            enabled = true;
            name = "Malicious URL Blocklist (URLHaus)";
            url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_11.txt";
            id = 5;
          }
          {
            enabled = true;
            name = "uBlock filters – Badware risks";
            url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_50.txt";
            id = 6;
          }
          {
            enabled = true;
            name = "The Big List of Hacked Malware Web Sites";
            url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_9.txt";
            id = 7;
          }
        ];
      };
    };
  };

  networking = {
    firewall = {
      allowedUDPPorts = [ dnsPort ];
    };
  };
}
