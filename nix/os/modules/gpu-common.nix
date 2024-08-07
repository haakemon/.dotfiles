{ pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.vulkan-tools # graphics info
    pkgs.vulkan-headers
    pkgs.vulkan-loader
    pkgs.vulkan-validation-layers
    pkgs.clinfo # graphics info
    pkgs.glxinfo # graphics info
    pkgs.wayland-utils # graphics info
  ];

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
