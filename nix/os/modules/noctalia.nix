{ config
, pkgs
, inputs
, ...
}:
{

  imports = [
    ./quickshell.nix
  ];

  # environment.systemPackages = [
  #   inputs.noctalia.packages.${pkgs.system}.default
  #   # ... maybe other stuff
  # ];

  home-manager.users.${config.user-config.name} = {
    imports = [
      inputs.noctalia.homeModules.default
    ];

    programs.noctalia-shell = {
      enable = true;
    };

    programs.noctalia-shell.systemd.enable = true;
  };
}
