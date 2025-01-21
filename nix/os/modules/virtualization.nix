{ config
, pkgs
, lib
, ...
}:

{
  environment.systemPackages = [
    pkgs.podman-compose
  ];

  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
    oci-containers = {
      backend = "podman";
    };
  };

  home-manager.users.${config.configOptions.username} =
    { config
    , pkgs
    , lib
    , ...
    }:
    {
      programs.home-manager.enable = true;
      home = {
        sessionVariables = {
          PODMAN_COMPOSE_WARNING_LOGS = "false";
        };

        packages = [
          pkgs.dive # explore docker layers
          pkgs.podman-tui
        ];
      };
    };
}
