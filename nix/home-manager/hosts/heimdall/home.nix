{ config, pkgs, ... }:

{
  imports = [

    # TODO: Review
    # ../../modules/base.nix
    # ../../modules/browsers.nix
    # ../../modules/development.nix
    # ../../modules/git.nix
    # ../../modules/hypridle.nix
    # ../../modules/hyprlock.nix
    # ../../modules/mitmproxy.nix
    # ../../modules/noctalia.nix
    # ../../modules/obs-studio.nix
    # ../../modules/qmk.nix
    # ../../modules/zsh.nix
    # ../../modules/niri.nix
  ];

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
