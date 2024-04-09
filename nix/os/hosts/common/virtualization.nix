{ config, pkgs, ... }:

{
  services = {
    spice-vdagentd.enable = true;
  };

  environment.systemPackages = [
    pkgs.virt-viewer
    pkgs.spice
    pkgs.spice-gtk
    pkgs.spice-protocol
    pkgs.virtio-win
    pkgs.win-spice
    pkgs.libvirt
    pkgs.libguestfs-with-appliance
    pkgs.podman-compose
    pkgs.distrobox
  ];

  programs = {
    virt-manager.enable = true;
  };

  # boot.kernelParams = [ "amd_iommu=on" ];

  virtualisation = {
    # waydroid.enable = true;
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [ pkgs.OVMFFull.fd ];
      };
    };
    spiceUSBRedirection.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
    oci-containers = {
      backend = "podman";
    };
  };
}
