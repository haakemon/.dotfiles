{ config, pkgs, ... }:

{
  # TODO: This is currently niri-specific - should be moved to niri.nix if it gets enabled

  boot.kernelParams = [
    "quiet"
    "splash"
  ]; # systemd boot messges are written on top of tuigreet, so keep quiet

  services.greetd = {
    enable = true;
    vt = 7;
    settings = {
      default_session = {
        command = ''
          ${pkgs.greetd.tuigreet}/bin/tuigreet \
            --cmd niri-session \
            --remember \
            --remember-session \
            --time \
            --asterisks \
            --power-shutdown shutdown now \
            --power-reboot reboot \
            --greeting "Eat some bananas"
        '';
        # --time-format #strftime format

        user = "greeter";
      };
    };
  };

  systemd.tmpfiles.rules = [ "d '/var/cache/tuigreet' - greeter greeter - -" ];
}
