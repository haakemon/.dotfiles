{ config
, lib
, pkgs
, ...
}:
{
  options.wallpaper = {
    scriptPath = lib.mkOption {
      type = lib.types.str;
      description = "Path to the wallpaper script";
    };
  };

  config = {
    home-manager.users.${config.user-config.name} = {
      systemd.user.timers."wallpaper" = {
        Install.WantedBy = [ "timers.target" ];
        Timer = {
          OnCalendar = "*:0/30"; # Every 30 minutes
          Unit = "wallpaper.service";
        };
      };

      systemd.user.services."wallpaper" = {
        Unit = {
          Description = "Change wallpaper";
        };
        Service = {
          Type = "exec";
          ExecStart = config.wallpaper.scriptPath;
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
  };
}
