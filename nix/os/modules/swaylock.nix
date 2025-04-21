{ config, ... }:

{
  home-manager.users.${config.user-config.name} =
    { inputs
    , config
    , pkgs
    , ...
    }:
    {
      programs = {
        swaylock = {
          enable = true;
          package = pkgs.swaylock-effects;
          settings = {
            clock = true;
            #color = "00000000";
            show-failed-attempts = true;
            indicator = true;
            indicator-radius = 220;
            indicator-thickness = 25;
            # line-color = "#${background}";
            # ring-color = "${mbg}";
            # inside-color = "#${background}";
            # key-hl-color = "#${accent}";
            # separator-color = "00000000";
            # text-color = "#${foreground}";
            # text-caps-lock-color = "";
            # line-ver-color = "#${accent}";
            # ring-ver-color = "#${accent}";
            # inside-ver-color = "#${background}";
            # text-ver-color = "#${foreground}";
            # ring-wrong-color = "#${color9}";
            # text-wrong-color = "#${color9}";
            # inside-wrong-color = "#${background}";
            # inside-clear-color = "#${background}";
            # text-clear-color = "#${foreground}";
            # ring-clear-color = "#${color5}";
            # line-clear-color = "#${background}";
            # line-wrong-color = "#${background}";
            # bs-hl-color = "#${accent}";
            line-uses-ring = false;
            grace = 8;
            #datestr = "%d.%m";
            fade-in = ".500";
            ignore-empty-password = true;
            screenshots = true;
            effect-blur = "6x6";
            font = "Victor Mono";
            effect-greyscale = true;
          };
        };
      };
    };
}
