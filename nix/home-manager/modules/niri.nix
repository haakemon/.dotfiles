{ config, pkgs, ... }:

{
  home = {
    sessionVariables = {
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
      NIXOS_OZONE_WL = "1";
    };
  };
}
