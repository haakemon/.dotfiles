{ config, lib, ... }:
# let
#   inherit (import ./options-local.nix)
#     gpuType
#     gpuIntelBusId
#     gpuNvidiaBusId;
# in
{
  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
    nvidia = {
      modesetting.enable = true;

      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      powerManagement.enable = false;
      # Fine-grained power management. Turns off GPU when not in use.
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
      powerManagement.finegrained = false;

      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver).
      # Support is limited to the Turing and later architectures. Full list of
      # supported GPUs is at:
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
      # Only available from driver 515.43.04+
      # Currently alpha-quality/buggy, so false is currently the recommended setting.
      # In the below table, if three IDs are listed,
      # the first is the PCI Device ID,
      # the second is the PCI Subsystem Vendor ID,
      # and the third is the PCI Subsystem Device ID.
      # 25BA ?
      open = false;

      # Enable the Nvidia settings menu,
      # accessible via `nvidia-settings`.
      nvidiaSettings = true;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = config.boot.kernelPackages.nvidiaPackages.stable;


      prime = {
        # offload = { # sync.enable needs to be false if this is activated
        #   enable = true;
        #   enableOffloadCmd = true;
        # };
        sync.enable = true;
        intelBusId = "${gpuIntelBusId}";
        nvidiaBusId = "${gpuNvidiaBusId}";
      };
    };
  };
}
