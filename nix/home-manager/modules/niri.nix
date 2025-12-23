{ config, pkgs, hostName, ... }:

{
  home = {
    sessionVariables = {
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
      NIXOS_OZONE_WL = "1";
    };

    file = {
      ".config/niri".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/niri/hosts/${hostName}";
    };
  };
}
