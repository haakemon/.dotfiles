{ config, pkgs, lib, ... }:

{
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      timeout = 5;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        devices = [ "nodev" ];
        efiSupport = true;
        enable = true;
        useOSProber = lib.mkDefault true;
        configurationLimit = 20;
        splashImage = "${config.configOptions.userHome}/.dotfiles/iamroot.png";
      };
    };
  };
}
