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
      gnome.gnome-keyring.enable = true;
      xserver = {
        enable = true;
        xkb.layout = "no";
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
      gvfs.enable = true; # Mount, trash, and other functionalities
      playerctld.enable = true;
    })
  ];

  xdg.icons.enable = true;
  gtk.iconCache.enable = true;

  console.keyMap = "no";
  security.rtkit.enable = true;
  security.pam.services.ags = { }; # TODO: merge with home-manager ags

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
  };

  environment.systemPackages = [
    pkgs.usbutils
    pkgs.pciutils
    pkgs.nixpkgs-fmt # formatting .nix files
  ] ++ lib.optionals (!config.configOptions.headless) [
    pkgs.libnotify
    pkgs.victor-mono # font
  ];

  system = {
    autoUpgrade.enable = true;
    autoUpgrade.allowReboot = false;
  };

  programs = lib.mkMerge [
    {
      bash = {
        completion.enable = true;
      };
      dconf.enable = true;
      nix-ld.enable = true;
    }

    (lib.mkIf (!config.configOptions.headless) {
      plotinus.enable = true;
      corectrl.enable = true;
    })
  ];

  time.timeZone = "Europe/Oslo";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_CTYPE = "en_US.UTF-8";
      LC_COLLATE = "en_US.UTF-8";
      LC_MESSAGES = "en_US.UTF-8";

      LC_ADDRESS = "nb_NO.UTF-8";
      LC_IDENTIFICATION = "nb_NO.UTF-8";
      LC_MEASUREMENT = "nb_NO.UTF-8";
      LC_MONETARY = "nb_NO.UTF-8";
      LC_NAME = "nb_NO.UTF-8";
      LC_NUMERIC = "nb_NO.UTF-8";
      LC_PAPER = "nb_NO.UTF-8";
      LC_TELEPHONE = "nb_NO.UTF-8";
      LC_TIME = "nb_NO.UTF-8";
    };
  };

  home-manager.users.${config.configOptions.username} = { config, pkgs, ... }: {
    programs.home-manager.enable = true;
  };
}
