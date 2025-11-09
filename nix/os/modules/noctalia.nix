{ config
, pkgs
, inputs
, ...
}:
{

  imports = [
    ./quickshell.nix
  ];

  home-manager.users.${config.user-config.name} = {
    imports = [
      inputs.noctalia.homeModules.default
    ];

    programs.noctalia-shell = {
      enable = true;
    };

    programs.noctalia-shell.systemd.enable = true;



    # home = {
    #   file = {
    #     ".config/noctalia/colors.json".source = config.lib.file.mkOutOfStoreSymlink "${config.user-config.home}/.dotfiles/quickshell/noctalia//colors.json";
    #   };
    # };
  };
}
