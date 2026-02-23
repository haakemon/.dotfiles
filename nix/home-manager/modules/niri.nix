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

      ".config/hypr/hypridle.conf".source =
        config.lib.file.mkOutOfStoreSymlink "${config.user-config.home}/.dotfiles/hypr/hypridle.conf";
      ".config/hypr/hyprlock.conf".source =
        config.lib.file.mkOutOfStoreSymlink "${config.user-config.home}/.dotfiles/hypr/hyprlock.conf";
    };
  };
}
