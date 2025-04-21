{ config, ... }:

{
  home-manager.users.${config.user-config.name} =
    { inputs
    , config
    , pkgs
    , ...
    }:
    {
      services.batsignal.enable = true;
      services.batsignal.extraArgs = [
        "-d 5" # danger level
        "-c 10" # critical level
        "-w 15" # warning level

        "-D ${pkgs.systemd}/bin/systemctl suspend" # danger command
        "-C Battery at 10%" # critical level message
        "-W Battery at 15%" # warning level message

        "-P Charging battery"
      ];
    };
}
