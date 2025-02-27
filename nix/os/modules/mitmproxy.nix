{ config, ... }:

{
  home-manager.users.${config.configOptions.username} =
    { config
    , pkgs
    , ...
    }:
    {
      home.packages = [
        pkgs.mitmproxy
      ];

      programs = {
        zsh = {
          shellAliases = {
            mitmproxy = "mitmproxy --set confdir=${config.home.sessionVariables.XDG_CONFIG_HOME}/mitmproxy";
            mitmweb = "mitmweb --set confdir=${config.home.sessionVariables.XDG_CONFIG_HOME}/mitmproxy";
          };
        };
      };

    };
}
