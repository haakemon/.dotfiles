{ config, pkgs, lib, ... }:


{
  services = {
    desktopManager.cosmic = {
      enable = true;
      xwayland.enable = true;
    };
    displayManager.cosmic-greeter.enable = true;
  };
}
