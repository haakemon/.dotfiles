{ config, pkgs, ... }:

{
  home-manager.users.${config.configOptions.username} =
    { config
    , pkgs
    , lib
    , ...
    }:

    {
      home = {
        packages = [
          # pkgs.blender
          # pkgs.prusa-slicer
          pkgs.bambu-studio
          (pkgs.plasticity.overrideAttrs rec {
            # https://nixpk.gs/pr-tracker.html?pr=340999
            version = "24.2.0";
            src = pkgs.fetchurl {
              url = "https://github.com/nkallen/plasticity/releases/download/v${version}/Plasticity-${version}-1.x86_64.rpm";
              hash = "sha256-3dHS7chTgoD35AV/q8DHIYl43KbCsoFYEqSQHXm05tg=";
            };
          })
          pkgs.fstl
        ];
      };
    };
}
