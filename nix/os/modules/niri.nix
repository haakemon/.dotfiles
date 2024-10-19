{ config
, pkgs
, inputs
, ...
}:

{
  imports = [
    ./ags.nix
    ./hyprlock.nix
    ./hypridle.nix
  ];
  nixpkgs.overlays = [
    inputs.niri.overlays.niri
    (self: super: {
      xwayland-satellite = super.callPackage ../apps/xwayland-satellite/package.nix { };
    })
  ];

  programs = {
    niri.enable = true;
  };

  environment.systemPackages = [
    pkgs.xwayland-satellite
    pkgs.swayidle
    pkgs.wf-recorder # screen recording utility
    pkgs.slurp # screen geometry picker utility
  ];

  services = {
    blueman.enable = true;
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-kde
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal
    ];
    configPackages = [
      pkgs.xdg-desktop-portal-kde
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal
    ];
  };

  home-manager.users.${config.configOptions.username} =
    { config, pkgs, ... }:
    {
      programs = {
        niri.config = null;

        wlogout = {
          enable = true;
          layout = [
            {
              label = "lock";
              action = "loginctl lock-session";
              text = "Lock";
              keybind = "l";
            }
            {
              label = "hibernate";
              action = "systemctl hibernate";
              text = "Hibernate";
              keybind = "h";
            }
            {
              label = "suspend";
              action = "systemctl suspend";
              text = "Suspend";
              keybind = "u";
            }
            {
              label = "reboot";
              action = "systemctl reboot";
              text = "Reboot";
              keybind = "r";
            }
            {
              label = "shutdown";
              action = "systemctl poweroff";
              text = "Shutdown";
              keybind = "s";
            }
          ];
        };
      };

      # home = {
      #   file = {
      #     ".config/niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "${config.configOptions.userHome}/.dotfiles/niri/config.kdl";
      #   };
      # };
    };
}
