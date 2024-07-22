{ config, pkgs, ... }:

{
  # TODO: This is currently niri-specific - should be moved to niri.nix if it gets enabled
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
