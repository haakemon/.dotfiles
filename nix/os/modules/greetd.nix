{ config, pkgs, ... }:

{
  # TODO: This is currently niri-specific - should be moved to niri.nix if it gets enabled

  boot.kernelParams = [ "quiet" "splash"]; # systemd boot messges are written on top of tuigreet, so keep quiet

  services.greetd = {
    enable = true;
    vt = 2;
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

        user = "greeter";
      };
    };
  };


  # this is a life saver.
  # literally no documentation about this anywhere.
  # might be good to write about this...
  # https://www.reddit.com/r/NixOS/comments/u0cdpi/tuigreet_with_xmonad_how/
  # systemd.services.greetd.serviceConfig = {
  #   Type = "idle";
  #   StandardInput = "tty";
  #   StandardOutput = "tty";
  #   StandardError = "journal"; # Without this errors will spam on screen
  #   # Without these bootlogs will spam on screen
  #   TTYReset = true;
  #   TTYVHangup = true;
  #   TTYVTDisallocate = true;
  # };
}
