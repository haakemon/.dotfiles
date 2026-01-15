{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            # Shared EFI boot partition
            boot = {
              size = "4G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };

            cryptroot = {
              size = "100%";
              content = {
                type = "luks";
                name = "cryptroot";
                settings = {
                  allowDiscards = true;
                };
                content = {
                  type = "lvm_pv";
                  vg = "vg-main";
                };
              };
            };
          };
        };
      };
    };

    # Single LVM volume group containing all partitions
    lvm_vg = {
      vg-main = {
        type = "lvm_vg";
        lvs = {
          # Shared user data partition
          shared = {
            size = "300G"; # Adjust based on your needs
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/mnt/shared";
              mountOptions = [ "defaults" "noatime" ];
            };
          };

          # Shared swap (used by all OSes)
          swap = {
            size = "34G";
            content = {
              type = "swap";
            };
          };

          # NixOS root
          nixos = {
            size = "100%FREE"; # Use remaining space
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
              mountOptions = [ "defaults" "noatime" ];
            };
          };

          # Ubuntu root (leave unmounted for NixOS install)
          ubuntu = {
            size = "200G";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = null; # Don't mount during NixOS install
            };
          };

          # Arch/Endeavour root (leave unmounted for NixOS install)
          endeavour = {
            size = "200G";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = null; # Don't mount during NixOS install
            };
          };
        };
      };
    };
  };
}
