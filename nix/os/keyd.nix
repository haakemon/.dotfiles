{ config, ... }:
# keys https://github.com/rvaiya/keyd/blob/2338f11b1ddd81eaddd957de720a3b4279222da0/t/keys.py#L18
# force terminate: <backspace>+<escape>+<enter>
# nix-shell -p keyd && sudo keyd monitor
{
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        settings = {
          main = {
            "\\" = "G-2"; # @
            compose = "noop";
            capslock = "overload(nav, esc)";
          };
          "shift" = {
            "4" = "G-4"; # $
            "\\" = "S-\\"; # *
          };
          "altgr" = {
            "2" = "\\"; # '
            "7" = "equal"; # \
          };
          "control+alt" = {
            z = "volumedown";
            x = "volumeup";
            s = "playpause";
            a = "previoussong";
            d = "nextsong";
            "102nd" = "mute";
          };
          "shift+altgr" = {
            "7" = "`"; # |
            "8" = "G-7"; # {
            "9" = "G-0"; # }
          };
          "nav" = {
            "u" = "home";
            "o" = "end";
            "i" = "up";
            "k" = "down";
            "j" = "left";
            "l" = "right";
            "p" = "pageup";
            ";" = "pagedown"; # ;=ø
            "space" = "delete";
          };
        };
      };
    };
  };
}
