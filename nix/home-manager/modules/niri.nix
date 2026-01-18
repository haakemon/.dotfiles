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

  services = {
    hypridle = {
      settings = {
        general = {
          ignore_dbus_inhibit = false;
          lock_cmd = "pidof hyprlock || hyprlock";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "${pkgs.niri}/bin/niri msg action power-on-monitors";
        };

        listener = [
          {
            timeout = 600;
            on-timeout = "loginctl lock-session";
          }
          {
            timeout = 1200;
            on-timeout = "${pkgs.niri}/bin/niri msg action power-off-monitors";
            on-resume = "${pkgs.niri}/bin/niri msg action power-on-monitors";
          }
          {
            timeout = 7200;
            on-timeout = "${pkgs.systemd}/bin/systemctl suspend";
          }
        ];
      };
    };
  };
}
