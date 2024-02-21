{ pkgs, lib, ... }:
let
  inherit (import ./options.nix)
    gpuType;
in
lib.mkIf ("${gpuType}" == "amd") {
  boot = {
    initrd.kernelModules = [ "amdgpu" ];
  };

  hardware = {
    opengl = {
      enable = true;

      # ## amdvlk: an open-source Vulkan driver from AMD
      # extraPackages = [ pkgs.amdvlk ];
      # extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];

      driSupport = true;
      driSupport32Bit = true;
      extraPackages = [
        pkgs.rocmPackages.clr.icd
      ];
    };
  };

  services.xserver = {
    enable = true;
    videoDrivers = [ "amdgpu" ];
  };

  environment.variables = {
    VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";
    AMD_VULKAN_ICD = "RADV";
  };

  systemd.tmpfiles.rules = [
    "L+ /opt/rocm/hip - - - - ${pkgs.rocmPackages.clr}"
  ];

  environment.systemPackages = with pkgs; [
    vulkan-tools # graphics info
    vulkan-headers
    vulkan-loader
    vulkan-validation-layers
    clinfo # graphics info
    glxinfo # graphics info
    wayland-utils # graphics info
  ];

  chaotic.mesa-git.enable = true;
}
