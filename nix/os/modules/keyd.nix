{ config, ... }:
# keys https://github.com/rvaiya/keyd/blob/2338f11b1ddd81eaddd957de720a3b4279222da0/t/keys.py#L18
# force terminate: <backspace>+<escape>+<enter>
# nix shell nixpkgs#keyd
# sudo keyd monitor
let
  homeKeyboard = "17ef:6116";
  workKeyboard = "0fac:0ade";
  workLaptop = "0001:0001";
in
{
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [
          homeKeyboard
          workKeyboard
          workLaptop
        ];
        settings = {
          main = {
            "\\" = "G-2"; # @
            compose = "noop";
            # capslock = "overload(nav, esc)";

            # convenience overloads - not working...
            # "r" = "overloadt(control+r, r, 200)";
            # "t" = "overloadt(control+t, t, 200)";
            # tab = "C-S-7";
            # tab = "overloadt(macro(C-S-7), tab, 200)";
            # tab = "overloadt(macro(C+S-7), tab, 200)";

            # copy/paste - not working...
            # "c" = "overloadt(control+insert, c, 200)";
            # "v" = "overloadt(shift+insert, v, 200)";

            # home row mods
            "a" = "overloadt(meta, a, 200)";
            "s" = "overloadt(alt, s, 200)";
            "d" = "overloadt(shift, d, 200)";
            "f" = "overloadt(control, f, 200)";
            "j" = "overloadt(control, j, 200)";
            "k" = "overloadt(shift, k, 200)";
            "l" = "overloadt(alt, l, 200)";
            ";" = "overloadt(meta, ;, 200)";
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
