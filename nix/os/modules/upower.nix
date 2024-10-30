{ config, ... }:

{
  services = {
    upower = {
      enable = true;
      percentageLow = 15;
      percentageCritical = 6;
      percentageAction = 3;
    };
  };
}
