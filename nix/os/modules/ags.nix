{ config, ... }:

{
  security.pam.services.ags = { };

  home-manager.users.${config.configOptions.username} =
    { inputs
    , config
    , pkgs
    , ...
    }:
    {
      imports = [
        inputs.ags.homeManagerModules.default
      ];

      systemd.user.services."ags" = {
        Unit = {
          Description = "Bar and notifications";
          PartOf = "graphical-session.target";
          After = "graphical-session.target";
          Requisite = "graphical-session.target";
          BindsTo = "graphical-session.target";
        };
        Install.WantedBy = [ "graphical-session.target" ];
        Service = {
          Type = "notify";
          NotifyAccess = "all";
          ExecStart = "${config.configOptions.userHome}/.dotfiles/ags_v1/start.sh";
          StandardOutput = "jounral";
          Restart = "on-failure";
          RestartSec = 10;
        };
      };

      programs = {
        ags = {
          enable = true;

          # null or path, leave as null if you don't want hm to manage the config
          #configDir = ../ags_v1;
          configDir = null;

          # additional packages to add to gjs's runtime
          extraPackages = [
            pkgs.gtksourceview
            pkgs.webkitgtk
            pkgs.accountsservice
            pkgs.gvfs
          ];
        };
      };
    };
}
