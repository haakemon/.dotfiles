{ pkgs, ... }:

{
  imports =
    [
      ./gpu-common.nix
    ];
  boot = {
    initrd.kernelModules = [ "amdgpu" ];
  };

  hardware = {
    opengl = {
      # ## amdvlk: an open-source Vulkan driver from AMD
      # extraPackages = [ pkgs.amdvlk ];
      # extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
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
    # DISABLE_LAYER_AMD_SWITCHABLE_GRAPHICS_1=1;
  };

  systemd.tmpfiles.rules = [
    "L+ /opt/rocm/hip - - - - ${pkgs.rocmPackages.clr}"
  ];

  chaotic.mesa-git.enable = true;
}
