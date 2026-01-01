{ config
, pkgs
, lib
, ...
}:
let
  gtkThemeName = "adw-gtk3-dark";
in
{
  services = {
    gnome.gnome-keyring.enable = true;
    orca.enable = true;
    xserver = {
      enable = true;
      xkb.layout = "no";
    };
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      socketActivation = true;
      wireplumber.enable = true;
    };
    gvfs.enable = true; # Mount, trash, and other functionalities
    playerctld.enable = true;
    tuned.enable = true;
    upower = {
      enable = true;
      percentageLow = 15;
      percentageCritical = 6;
      percentageAction = 3;
    };
  };

  xdg.icons.enable = true;
  gtk.iconCache.enable = true;

  hardware = {
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  };

  fonts.packages = [
    pkgs.victor-mono
    pkgs.nerd-fonts.victor-mono
    pkgs.fira-sans
    pkgs.roboto
    pkgs.nerd-fonts._0xproto
    pkgs.nerd-fonts.droid-sans-mono
    pkgs.jetbrains-mono
    pkgs.noto-fonts
    pkgs.noto-fonts-color-emoji
    pkgs.noto-fonts-cjk-sans
    pkgs.noto-fonts-cjk-serif
    pkgs.material-symbols
    pkgs.material-icons
  ];

  environment.systemPackages = [
    pkgs.usbutils
    pkgs.pciutils
    pkgs.statix
    pkgs.nixpkgs-fmt # formatting .nix files
    pkgs.libnotify
  ];
}
