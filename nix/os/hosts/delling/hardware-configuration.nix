# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "thunderbolt"
        "nvme"
        "usb_storage"
        "usbhid"
        "uas"
        "sd_mod"
        "rtsx_pci_sdmmc"
      ];
      kernelModules = [
        "dm-snapshot"
      ];
    };
    kernelModules = [
      "kvm-intel"
    ];
    blacklistedKernelModules = ["nouveau"];
    kernelParams = ["i915.modeset=1"];
    extraModulePackages = [ ];
  };

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/23714112-b681-4c67-b5cf-cbfe5d1d6fb9";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/12CE-A600";
      fsType = "vfat";
    };

  swapDevices = [
    {
      device = "/dev/disk/by-uuid/cab21277-b29b-4e00-bfba-ea236787be67";
    }
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s13f0u2u2u1.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
