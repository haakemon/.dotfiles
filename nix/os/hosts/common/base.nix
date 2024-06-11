{ config, pkgs, lib, ... }:

{
  nixpkgs.overlays = [
    (self: super: {
      #  gitbutler = super.callPackage ../../apps/gitbutler/package.nix { };
      #  gitbutler-ui = super.callPackage ../../apps/gitbutler-ui/package.nix { };
    })
  ];

  services = lib.mkMerge [
    {
      # execute to update:
      # fwupdmgr refresh && fwupdmgr update
      fwupd.enable = true;
    }

    (lib.mkIf (!config.configOptions.headless) {
      xserver = {
        enable = true;
        xkb.layout = "no";
      };
      printing = {
        enable = true;
        startWhenNeeded = true;
        webInterface = false;
        cups-pdf.enable = true;
        drivers = [ pkgs.gutenprint ];
        cups-pdf.instances = {
          pdf = {
            settings = {
              Out = "\${HOME}/Documents";
            };
          };
        };
      };
      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        socketActivation = true;
        wireplumber.enable = true;
      };
      scrutiny = {
        enable = true;
        collector.enable = true;
        settings.web.listen.port = 8999;
      };
    })
  ];

  xdg.portal = lib.mkIf (!config.configOptions.headless) {
    enable = true;
    wlr.enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal
    ];
    configPackages = [
      pkgs.xdg-desktop-portal-gtk
      #pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal
    ];
  };

  sound.enable = true;

  console.keyMap = "no";
  security.rtkit.enable = true;

  hardware = {
    enableRedistributableFirmware = true;
    pulseaudio.enable = false;
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  };

  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nixFlakes;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
    optimise.automatic = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  environment.systemPackages = [
    pkgs.usbutils
    pkgs.pciutils
    pkgs.nixpkgs-fmt # formatting .nix files
  ] ++ lib.optionals (!config.configOptions.headless) [
    pkgs.libnotify
    pkgs.victor-mono # font
    pkgs.aha # ANSI HTML Adapter
    pkgs.mako # desktop notifications
    pkgs.waybar
  ];

  system = {
    autoUpgrade.enable = true;
    autoUpgrade.allowReboot = false;
  };

  programs = lib.mkMerge [
    {
      bash = {
        enableCompletion = true;
      };
      zsh = {
        enable = true;
        enableBashCompletion = true;
      };
      fzf = {
        fuzzyCompletion = true;
        keybindings = true;
      };
      dconf.enable = true;
      nix-ld.enable = true;
    }

    (lib.mkIf (!config.configOptions.headless) {
      corectrl.enable = true;
    })
  ];
}
