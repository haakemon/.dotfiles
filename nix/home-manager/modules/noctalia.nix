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

  programs.noctalia-shell = {
    enable = true;
  };

  home = {
    file = {
      ".config/noctalia/colors.json".source =
        config.lib.file.mkOutOfStoreSymlink "${config.user-config.home}/.dotfiles/quickshell/noctalia/${hostName}/colors.json";
      ".config/noctalia/plugins.json".source =
        config.lib.file.mkOutOfStoreSymlink "${config.user-config.home}/.dotfiles/quickshell/noctalia/${hostName}/plugins.json";
      ".config/noctalia/settings.json".source =
        config.lib.file.mkOutOfStoreSymlink "${config.user-config.home}/.dotfiles/quickshell/noctalia/${hostName}/settings.json";
    };
  };
}
