{ config
, pkgs
, lib
, ...
}:

{
  environment.systemPackages =
    [
      pkgs.podman-compose
      pkgs.distrobox
    ]
    ++ lib.optionals (!config.configOptions.headless) [
      pkgs.virt-viewer
      pkgs.spice
      pkgs.spice-gtk
      pkgs.spice-protocol
      pkgs.virtio-win
      pkgs.win-spice
      pkgs.libvirt
      pkgs.libguestfs-with-appliance
    ];

  programs = lib.mkIf (!config.configOptions.headless) {
    virt-manager.enable = true;
  };

  services = lib.mkIf (!config.configOptions.headless) {
    spice-vdagentd.enable = true;
  };

  # boot.kernelParams = [ "amd_iommu=on" ];

  virtualisation = lib.mkMerge [
    {
      podman = {
        enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true;
      };
      oci-containers = {
        backend = "podman";
      };
    }

    (lib.mkIf (!config.configOptions.headless) {
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
    })
  ];

  home-manager.users.${config.configOptions.username} = { config, pkgs, ... }:
    {
      dconf.settings = lib.mkIf (!config.configOptions.headless) {
        # Settings for virt-manager https://nixos.wiki/wiki/Virt-manager
        "org/virt-manager/virt-manager/connections" = {
          autoconnect = [ "qemu:///system" ];
          uris = [ "qemu:///system" ];
        };
      };
    };
}
