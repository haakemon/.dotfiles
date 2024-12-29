
{
  config,
  pkgs,
  lib,
  ...
}:

{

systemd.services.podman-autostart = {
    enable = true;
    after = [ "podman.service" ];
    wantedBy = [ "multi-user.target" ];
    description = "Automatically start containers with --restart=unless-stopped tag";
    serviceConfig = {
      Type = "idle";
      User = config.configOptions.username;
      TimeoutStopSec = "60s";
      ExecStart = ''${pkgs.podman}/bin/podman start --all --filter restart-policy=unless-stopped'';
    };
  };
}