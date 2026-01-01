{ config
, pkgs
, inputs
, ...
}:
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  home = {
    packages = [
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

  programs.noctalia-shell = {
    enable = true;
    systemd.enable = true;
  };

  # home = {
  #   file = {
  #     ".config/noctalia/colors.json".source = config.lib.file.mkOutOfStoreSymlink "${config.user-config.home}/.dotfiles/quickshell/noctalia//colors.json";
  #   };
  # };
}
