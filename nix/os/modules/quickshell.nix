{ inputs
, config
, pkgs
, lib
, ...
}:

{

  environment.systemPackages = [
    # Quickshell stuff
    pkgs.qt6Packages.qt5compat
    pkgs.libsForQt5.qt5.qtgraphicaleffects
    pkgs.kdePackages.qtbase
    pkgs.kdePackages.qt5compat
    pkgs.kdePackages.qtdeclarative
  ];

  qt.enable = true;

  home-manager.users.${config.user-config.name} = {
    home = {
      packages = [
        # inputs.quickshell.packages.x86_64-linux.default
        (inputs.quickshell.packages.${pkgs.system}.default.override {
          withJemalloc = true;
          withQtSvg = true;
          withWayland = true;
          withX11 = false;
          withPipewire = true;
          withPam = true;
          withHyprland = false;
          withI3 = false;
        })

      ];
    };
  };
}
