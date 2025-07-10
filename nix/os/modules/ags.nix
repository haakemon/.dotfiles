{ inputs
, config
, pkgs
, ...
}:

{
  security.pam.services.ags = { };

  home-manager.users.${config.user-config.name} =
    { inputs
    , config
    , pkgs
    , ...
    }:
    {
      imports = [
        inputs.ags.homeManagerModules.default
      ];

      # systemd.user.services."ags" = {
      #   Unit = {
      #     Description = "AGS bar and notifications";
      #     PartOf = "graphical-session.target";
      #     After = "graphical-session-pre.target";
      #   };
      #   Install.WantedBy = [ "graphical-session.target" ];
      #   Service = {
      #     KillMode = "mixed";
      #     ExecStart = "${config.programs.ags.finalPackage}/bin/ags run ${config.user-config.home}/.dotfiles/ags/app.ts";
      #     Restart = "on-failure";
      #     StandardOutput = "null";
      #     StandardError = "null";
      #     RestartSec = 10;
      #   };
      # };

      programs = {
        ags = {
          enable = true;

          # null or path, leave as null if you don't want hm to manage the config
          configDir = null;

          # additional packages to add to gjs's runtime
          extraPackages = [
            inputs.astal.packages.${pkgs.system}.apps
            inputs.astal.packages.${pkgs.system}.auth
            inputs.astal.packages.${pkgs.system}.battery
            inputs.astal.packages.${pkgs.system}.bluetooth
            inputs.astal.packages.${pkgs.system}.cava
            inputs.astal.packages.${pkgs.system}.greet
            inputs.astal.packages.${pkgs.system}.mpris
            inputs.astal.packages.${pkgs.system}.network
            inputs.astal.packages.${pkgs.system}.notifd
            inputs.astal.packages.${pkgs.system}.powerprofiles
            inputs.astal.packages.${pkgs.system}.tray
            inputs.astal.packages.${pkgs.system}.wireplumber
            pkgs.fzf
          ];
        };
      };
    };
}
