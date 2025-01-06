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
          Description = "AGS bar and notifications";
          PartOf = "graphical-session.target";
          After = "graphical-session.target";
          Requisite = "graphical-session.target";
          BindsTo = "graphical-session.target";
        };
        Install.WantedBy = [ "graphical-session.target" ];
        Service = {
          Type = "exec";
          KillMode = "mixed";
          ExecStart = "${config.programs.ags.finalPackage}/bin/ags run ${config.configOptions.userHome}/.dotfiles/ags/app.ts";
          StandardOutput = "journal";
          Restart = "on-failure";
          RestartSec = 10;
        };
      };

      home.packages = [
        inputs.ags.packages.${pkgs.system}.apps
        inputs.ags.packages.${pkgs.system}.auth
        inputs.ags.packages.${pkgs.system}.battery
        inputs.ags.packages.${pkgs.system}.bluetooth
        inputs.ags.packages.${pkgs.system}.cava
        inputs.ags.packages.${pkgs.system}.greet
        inputs.ags.packages.${pkgs.system}.mpris
        inputs.ags.packages.${pkgs.system}.network
        inputs.ags.packages.${pkgs.system}.notifd
        inputs.ags.packages.${pkgs.system}.powerprofiles
        inputs.ags.packages.${pkgs.system}.tray
        inputs.ags.packages.${pkgs.system}.wireplumber
      ];

      programs = {
        ags = {
          enable = true;

          # null or path, leave as null if you don't want hm to manage the config
          configDir = null;

          # additional packages to add to gjs's runtime
          extraPackages = [
            inputs.ags.packages.${pkgs.system}.apps
            inputs.ags.packages.${pkgs.system}.auth
            inputs.ags.packages.${pkgs.system}.battery
            inputs.ags.packages.${pkgs.system}.bluetooth
            inputs.ags.packages.${pkgs.system}.cava
            inputs.ags.packages.${pkgs.system}.greet
            inputs.ags.packages.${pkgs.system}.mpris
            inputs.ags.packages.${pkgs.system}.network
            inputs.ags.packages.${pkgs.system}.notifd
            inputs.ags.packages.${pkgs.system}.powerprofiles
            inputs.ags.packages.${pkgs.system}.tray
            inputs.ags.packages.${pkgs.system}.wireplumber
            pkgs.fzf
          ];
        };
      };
    };
}
