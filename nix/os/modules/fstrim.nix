{ config, ... }:

{
  services = {
    fstrim = {
      enable = true;
      interval = "weekly";
    };
  };
}
