# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, hostname, username, timezone, defaultLocale, extraLocale, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./boot.nix
      ./i18n.nix
      ./networking.nix
      ./virtualization.nix
      ./gpu-amd.nix
      ./gaming.nix
    ];

  services = {
    fwupd.enable = true;
    xserver = {
      enable = true;
      layout = "no";
      desktopManager.plasma5.enable = true;
      displayManager = {
        sddm = {
          enable = true;
          wayland.enable = true;
          autoNumlock = true;
          theme = "sugar-dark";
        };
        defaultSession = "plasmawayland";
      };
    };
    printing = {
      enable = true;
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
    };
    avahi = {
      enable = true;
      nssmdns4 = true;
    };
    hardware.openrgb = {
      enable = true;
      motherboard = "amd";
    };
  };

  xdg.portal.wlr.enable = true;

  console.keyMap = "no";

  sound.enable = true;
  security.rtkit.enable = true;

  hardware = {
    # spacenavd.enable = true; # 3D mouse support, not working?
    enableRedistributableFirmware = true;
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
    sane.enable = true; # Scanning
    pulseaudio.enable = false;
    bluetooth.enable = true;
    logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
  };

  systemd.user.services.jotta = {
    wantedBy = [ "default.target" ];
    serviceConfig = {
      Type = "exec";
      ExecStart = "${pkgs.jotta-cli}/bin/jottad";
    };
  };


  users.users.${username} = {
    isNormalUser = true;
    description = "${username}";
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
      "video"
      "render"
    ];
    shell = pkgs.zsh;
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

  environment.systemPackages = let themes = pkgs.callPackage ./sddm-themes.nix { }; in [
    pkgs.usbutils
    pkgs.pciutils
    pkgs.vulkan-tools # graphics info
    pkgs.clinfo # graphics info
    pkgs.glxinfo # graphics info
    pkgs.wayland-utils # graphics info
    pkgs.libvirt # virtualization
    pkgs.nixpkgs-fmt # formatting .nix files
    pkgs.kdeconnect
    pkgs.sddm-kcm # sddm gui settings
    pkgs.libnotify

    # Custom SDDM themes
    themes.sddm-sugar-dark
    themes.sddm-vivid-dark
  ];

  programs = {
    partition-manager.enable = true; # KDE Partition Manager
    bash = {
      enableCompletion = true;
    };
    zsh = {
      enable = true;
      enableBashCompletion = true;
    };
    xwayland.enable = true;
    fzf.fuzzyCompletion = true;
  };

  system = {
    autoUpgrade.enable = true;
    autoUpgrade.allowReboot = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
