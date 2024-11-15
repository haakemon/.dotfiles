{ config, ... }:

{
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
        Unit.Description = "Bar and notifications";
        Install.WantedBy = [ "graphical-session.target" ];
        Service = {
          ExecStart = "${config.configOptions.userHome}/.dotfiles/ags/start.sh";
          Restart = "on-failure";
          RestartSec = 10;
        };
      };

      programs = {
        ags = {
          enable = true;

          # null or path, leave as null if you don't want hm to manage the config
          #configDir = ../ags;
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
