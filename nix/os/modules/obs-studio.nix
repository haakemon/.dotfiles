{ config, ... }:

{
  boot = {
    extraModulePackages = [
      config.boot.kernelPackages.v4l2loopback
    ];
    kernelModules = [
      "v4l2loopback"
    ];
    extraModprobeConfig = ''
      options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
    '';
  };
  security.polkit.enable = true;

  home-manager.users.${config.configOptions.username} =
    { pkgs
    , ...
    }:

    {
      programs.obs-studio = {
        enable = true;
        plugins = [
          pkgs.obs-studio-plugins.wlrobs
          pkgs.obs-studio-plugins.obs-backgroundremoval
          pkgs.obs-studio-plugins.obs-pipewire-audio-capture
          pkgs.obs-studio-plugins.obs-mute-filter
          pkgs.obs-studio-plugins.obs-gradient-source
          pkgs.obs-studio-plugins.obs-composite-blur
          pkgs.obs-studio-plugins.droidcam-obs
        ];
      };
    };
}
