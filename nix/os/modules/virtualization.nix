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

  home-manager.users.${config.user-config.name} =
    { config
    , pkgs
    , lib
    , ...
    }:
    {
      programs.home-manager.enable = true;
      home = {
        sessionVariables = {
          PODMAN_COMPOSE_WARNING_LOGS = "false";
        };

        packages = [
          pkgs.dive # explore docker layers
          pkgs.podman-tui
        ];
      };
    };
}
