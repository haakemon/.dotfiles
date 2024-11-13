{ config, pkgs, ... }:

{
  hardware = {
    logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
  };

  environment.systemPackages = [ pkgs.pkgs.logiops_0_2_3 ];
}
