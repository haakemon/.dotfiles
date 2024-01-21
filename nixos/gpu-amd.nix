{ pkgs, ... }:

{
  boot = {
    initrd.kernelModules = [ "amdgpu" ];
  };

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = [
        pkgs.rocmPackages.clr.icd
      ];
    };
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
