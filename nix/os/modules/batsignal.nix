{ config, ... }:

{
  home-manager.users.${config.configOptions.username} =
    { inputs
    , config
    , pkgs
    , ...
    }:
    {
      services.batsignal.enable = true;
    };
}
