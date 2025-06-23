{ config
, pkgs
, lib
, ...
}:
{

  home-manager.users.${config.user-config.name} =
    { config
    , pkgs
    , lib
    , ...
    }:
    {

      systemd.user.timers."wallpaper" = {
        Install.WantedBy = [ "timers.target" ];
        Timer = {
          OnCalendar = "*:0/5"; # Every 5 minutes
          Unit = "wallpaper.service";
        };
      };

      systemd.user.services."wallpaper" = {
        Unit = {
          Description = "Change wallpaper";
        };
        Service = {
          Type = "exec";
          ExecStart = "${config.user-config.home}/.dotfiles/waypaper/${config.system-config.hostname}/random.sh";
          StandardOutput = "journal";
          Restart = "no";
        };
      };

      home = {
        packages = [
          pkgs.waypaper
          pkgs.swww
        ];
      };
    };
}
