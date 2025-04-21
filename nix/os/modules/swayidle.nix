{ config, ... }:

{
  home-manager.users.${config.user-config.name} =
    { inputs
    , config
    , pkgs
    , ...
    }:
    {

      services = {
        swayidle = {
          enable = true;
          events = [
            {
              event = "before-sleep";
              command = "${pkgs.swaylock-effects}/bin/swaylock -f";
            }
            {
              event = "lock";
              command = "lock";
            }
          ];
          timeouts = [
            {
              timeout = 300;
              command = "${pkgs.niri}/bin/niri msg action power-off-monitors";
            }
            {
              timeout = 3600;
              command = "${pkgs.swaylock-effects}/bin/swaylock -f";
            }
            {
              timeout = 7200;
              command = "${pkgs.systemd}/bin/systemctl suspend";
            }
          ];
        };
      };
    };
}
