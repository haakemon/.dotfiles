# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, hostname, username, timezone, defaultLocale, extraLocale, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./boot.nix
      ./networking.nix
    ];

  time.timeZone = "${timezone}";
  i18n = {
    defaultLocale = "${defaultLocale}";
    extraLocaleSettings = {
      LC_ADDRESS = "${extraLocale}";
      LC_IDENTIFICATION = "${extraLocale}";
      LC_MEASUREMENT = "${extraLocale}";
      LC_MONETARY = "${extraLocale}";
      LC_NAME = "${extraLocale}";
      LC_NUMERIC = "${extraLocale}";
      LC_PAPER = "${extraLocale}";
      LC_TELEPHONE = "${extraLocale}";
      LC_TIME = "${extraLocale}";
    };
  };

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
      nssmdns = true;
    };
    hardware.openrgb = {
      enable = true;
      motherboard  = "amd";
    };
  };

  console.keyMap = "no";

  sound.enable = true;
  security.rtkit.enable = true;

  hardware = {
    enableRedistributableFirmware = true;
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = [
        pkgs.rocmPackages.clr.icd
        pkgs.amdvlk
      ];
      extraPackages32 = [
        pkgs.driversi686Linux.amdvlk
      ];
    };
    sane.enable = true; # Scanning
    pulseaudio.enable = false;
    bluetooth.enable = true;
    logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
  };

  # Adding this (environment.variables.VK_ICD_FILENAMES) stops Portal RTX from working
  # Workaround: Add "VK_ICD_FILENAMES="" %command%" to launch options
  environment.variables.VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json:/run/opengl-driver/share/vulkan/icd.d/amd_icd64.json";
  environment.variables.AMD_VULKAN_ICD = "RADV";

  systemd.tmpfiles.rules = [
    "L+ /opt/rocm/hip - - - - ${pkgs.rocmPackages.clr}"
  ];

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
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  environment.systemPackages = let themes = pkgs.callPackage ./sddm-themes.nix {}; in [
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

    themes.sddm-sugar-dark
    themes.sddm-vivid-dark
  ];

  programs = {
    bash = {
      enableCompletion = true;
    };
    zsh = {
      enable = true;
      enableBashCompletion = true;
    };
    xwayland.enable = true;
    virt-manager.enable = true;
    fzf.fuzzyCompletion = true;
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    # Need to add "gamemoderun %command%" to each Steam game,
    # or start Steam with gamemoderun steam-runtime to apply to all games
    # downside is that gamemode will run as long as Steam is running
    gamemode.enable = true;
  };

  system = {
    autoUpgrade.enable = true;
    autoUpgrade.allowReboot = true;
  };

  virtualisation = {
    # waydroid.enable = true;
    libvirtd.enable = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
