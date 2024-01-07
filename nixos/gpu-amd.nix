{ pkgs, ... }:

{
  boot = {
    initrd.kernelModules = [ "amdgpu" ];
  };

  hardware = {
    opengl = {
      extraPackages = [
        pkgs.rocmPackages.clr.icd
      ];
    };
  };

  # Adding this (environment.variables.VK_ICD_FILENAMES) stops Portal RTX from working
  # Workaround: Add "VK_ICD_FILENAMES="" %command%" to launch options
  environment.variables.VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";
  environment.variables.AMD_VULKAN_ICD = "RADV";

  systemd.tmpfiles.rules = [
    "L+ /opt/rocm/hip - - - - ${pkgs.rocmPackages.clr}"
  ];
}
