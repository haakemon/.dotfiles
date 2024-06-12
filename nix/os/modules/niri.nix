{ config, pkgs, ... }:

{
  nixpkgs.overlays = [
    (self: super: {
      xwayland-satellite = super.callPackage ../apps/xwayland-satellite/package.nix { };
    })
  ];

  programs = {
    niri.enable = true;
  };

  environment.systemPackages = [
    pkgs.xwayland-satellite
    # pkgs.swaybg
    pkgs.swayidle
  ];

  services = {
    blueman.enable = true;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    xdgOpenUsePortal = true;
  };

  home-manager.users.${config.configOptions.username} = {
    imports =
      [
        ./home-manager/ags.nix
        ./home-manager/swaylock.nix
      ];
    programs = {
      niri.config = null;

      wlogout = {
        enable = true;
        layout = [
          {
            label = "shutdown";
            action = "systemctl poweroff";
            text = "Shutdown";
            keybind = "s";
          }
          {
            label = "reboot";
            action = "systemctl reboot";
            text = "Reboot";
            keybind = "r";
          }
          {
            label = "logout";
            action = "sleep 1; niri msg action quit";
            text = "Logout";
            keybind = "l";
          }
        ];
      };
    };

    services = {
      swayidle = {
        enable = true;
        events = [
          { event = "before-sleep"; command = "${pkgs.swaylock-effects}/bin/swaylock -f"; }
          { event = "lock"; command = "lock"; }
        ];
        timeouts = [
          { timeout = 300; command = "${pkgs.niri}/bin/niri msg action power-off-monitors"; }
          { timeout = 3600; command = "${pkgs.swaylock-effects}/bin/swaylock -f"; }
          { timeout = 7200; command = "${pkgs.systemd}/bin/systemctl suspend"; }
        ];
      };
    };

  };
}
