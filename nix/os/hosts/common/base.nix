{ config, pkgs, lib, ... }:

{
  nixpkgs.overlays = [
    (self: super: {
      gitbutler = super.callPackage ../../apps/gitbutler/package.nix { };
      gitbutler-ui = super.callPackage ../../apps/gitbutler-ui/package.nix { };
    })
  ];

  services = lib.mkMerge [
    {
      # execute to update:
      # fwupdmgr refresh && fwupdmgr update
      fwupd.enable = true;
    }

    (lib.mkIf (!config.configOptions.headless) {
      desktopManager.plasma6.enable = true;
      gnome.at-spi2-core.enable = true; # requirement for orca screen reader
      xserver = {
        enable = true;
        xkb.layout = "no";
        displayManager = {
          sddm = {
            enable = true;
            wayland.enable = true;
            autoNumlock = true;
          };
          defaultSession = "plasma";
        };
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
      pkgs.xdg-desktop-portal
    ];
    configPackages = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal
    ];
  };

  sound.enable = true;

  console.keyMap = "${config.configOptions.consoleKeymap}";
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
    pkgs.kdePackages.kimageformats
    pkgs.kdePackages.sddm-kcm # sddm gui settings
    pkgs.libnotify
    pkgs.victor-mono # font
    pkgs.aha # ANSI HTML Adapter
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
      xwayland.enable = true;
      fzf.fuzzyCompletion = true;
      dconf.enable = true;
    }

    (lib.mkIf (!config.configOptions.headless) {
      partition-manager.enable = true; # KDE Partition Manager
      corectrl.enable = true;
      kdeconnect.enable = true;
    })
  ];
}
