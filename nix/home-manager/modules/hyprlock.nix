{ config, ... }:

{
  programs = {
    hyprlock = {
      enable = true;
      settings = {
        general = {
          disable_loading_bar = true;
          grace = 8;
          hide_cursor = true;
          no_fade_in = false;
          no_fade_out = false;
        };

        background = [
          {
            path = "screenshot";
            blur_passes = 3;
            blur_size = 3;
          }
        ];

        # https://github.com/MrVivekRajan/Hyprlock-Styles
        input-field = [
          {
            size = "350, 60";
            position = "0, -290";
            dots_center = true;
            halign = "center";
            valign = "center";
            outline_thickness = 2;
            fade_on_empty = true;
            outer_color = "rgba(0, 0, 0, 0)";
            inner_color = "rgba(100, 114, 125, 0.5)";
            font_color = "rgb(200, 200, 200)";
            placeholder_text = "";
            hide_input = true;
          }
        ];

        label = [
          # Hour-Time
          {
            text = ''cmd[update:1000] echo -e "$(date +"%H")"'';
            color = "rgba(255, 185, 0, .6)";
            font_size = 180;
            position = "0, 300";
            halign = "center";
            valign = "center";
          }

          # Minute-Time
          {
            text = ''cmd[update:1000] echo -e "$(date +"%M")"'';
            color = "rgba(255, 255, 255, .6)";
            font_size = 180;
            position = "0, 75";
            halign = "center";
            valign = "center";
          }

          # Day-Date-Month
          {
            text = ''cmd[update:1000] echo "<span color='##ffffff99'>$(date '+%A, ')</span><span color='##ffb90099'>$(date '+%d %B')</span>"'';
            color = "rgba(255, 255, 255, .6)";
            font_size = 30;
            position = "0, -80";
            halign = "center";
            valign = "center";
          }
        ];

      };
    };
  };

}
