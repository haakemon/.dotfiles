{ config
, pkgs
, inputs
, hostName
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

    file = {
      ".config/noctalia/colors.json".source =
        config.lib.file.mkOutOfStoreSymlink "${config.user-config.home}/.dotfiles/quickshell/noctalia/${hostName}/colors.json";
      ".config/noctalia/gui-settings.json".source =
        config.lib.file.mkOutOfStoreSymlink "${config.user-config.home}/.dotfiles/quickshell/noctalia/${hostName}/gui-settings.json";
      ".config/noctalia/settings.json".source =
        config.lib.file.mkOutOfStoreSymlink "${config.user-config.home}/.dotfiles/quickshell/noctalia/${hostName}/settings.json";
    };
  };

  # programs.noctalia-shell = {
  #   enable = true;
  #   systemd.enable = true;
  # };
}
