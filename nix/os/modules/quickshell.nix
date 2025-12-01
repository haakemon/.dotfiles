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

}
