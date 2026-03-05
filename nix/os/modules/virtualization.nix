{ config
, pkgs
, lib
, ...
}:

{
  environment.systemPackages =
    [
      pkgs.podman-compose
    ]
    ++ lib.optionals (!config.system-config.headless) [
      pkgs.virt-viewer
      pkgs.spice
      pkgs.spice-gtk
      pkgs.spice-protocol
      pkgs.virtio-win
      pkgs.win-spice
      pkgs.libvirt
      pkgs.libguestfs-with-appliance
    ];

  programs = lib.mkIf (!config.system-config.headless) {
    virt-manager.enable = true;
  };

  # https://github.com/NixOS/nixpkgs/pull/496839
  # services = lib.mkIf (!config.system-config.headless) {
  #   spice-vdagentd.enable = true;
  # };

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

    # https://github.com/NixOS/nixpkgs/pull/496839
    # (lib.mkIf (!config.system-config.headless) {
    #   # waydroid.enable = true;
    #   libvirtd = {
    #     enable = true;
    #     qemu = {
    #       swtpm.enable = true;
    #     };
    #   };
    #   spiceUSBRedirection.enable = true;
    # })
  ];
}
