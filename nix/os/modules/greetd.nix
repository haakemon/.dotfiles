{ config, pkgs, ... }:

{
  services.greetd = {
    enable = false;
    settings = {
      default_session = {
        command = ''
          ${pkgs.greetd.tuigreet}/bin/tuigreet
            --cmd niri-session
            --remember
            --remember-session
            --time
            --asterisks
            --power-shutdown shutdown now
            --power-reboot reboot
            --greeting "Hello from tuigreet"
        '';
        # --time-format #strftime format

        user = "${config.configOptions.username}";
      };
    };
  };
}
