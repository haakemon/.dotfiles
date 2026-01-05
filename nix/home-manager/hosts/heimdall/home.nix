{ config, pkgs, ... }:

{
  imports = [
    ../../modules/base.nix
    ../../modules/development.nix
    ../../modules/git.nix
    ../../modules/mitmproxy.nix
    ../../modules/qmk.nix
    ../../modules/zsh.nix
  ];

  home = {
    stateVersion = "24.05";
    username = config.user-config.name;
    homeDirectory = config.user-config.home;

  };

  # TODO: Replace this
  # systemd.user.timers."rclone-proton-immich" = {
  #   Install.WantedBy = [ "timers.target" ];
  #   Timer = {
  #     OnCalendar = "Mon 09:00:00";
  #     Unit = "rclone-proton-immich.service";
  #   };
  # };

  # systemd.user.services."rclone-proton-immich" = {
  #   Unit = {
  #     Description = "Rclone sync immich library to Proton Drive";
  #     After = "network-online.target";
  #   };
  #   Service = {
  #     Type = "exec";
  #     ExecStart = "${pkgs.rclone}/bin/rclone --rc sync ${config.user-config.home}/data/immich/files/ protondrive:computers/heimdall/immich";
  #     StandardOutput = "journal";
  #     Restart = "no";
  #   };
  # };
}
