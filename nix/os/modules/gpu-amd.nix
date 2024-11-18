{ pkgs, ... }:

{
  imports = [
    ./gpu-common.nix
  ];
  boot = {
    initrd.kernelModules = [ "amdgpu" ];
  };

  hardware = {
    graphics = {
      extraPackages = [
        pkgs.rocmPackages.clr.icd
        pkgs.vulkan-loader
        pkgs.vulkan-validation-layers
        pkgs.vulkan-extension-layer
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
    # DISABLE_LAYER_AMD_SWITCHABLE_GRAPHICS_1=1;
  };

  systemd.tmpfiles.rules = [
    "L+ /opt/rocm/hip - - - - ${pkgs.rocmPackages.clr}"
  ];

  chaotic.mesa-git.enable = true;
}
