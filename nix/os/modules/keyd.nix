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
            compose = "noop";
            esc = "timeout(esc, 200, f12)";
            capslock = "tab";

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
        };
      };
    };
  };
}
