{ config, lib, pkgs, ... }:

{
  programs = {
    steam = {
      enable = false; # installed via flatpak for better compatibility
      remotePlay.openFirewall = true;
      gamescopeSession.enable = true;
    };

    # Need to add "gamemoderun %command%" to each Steam game,
    # or start Steam with gamemoderun steam-runtime to apply to all games
    # downside is that gamemode will run as long as Steam is running
    gamemode = {
      enable = true;
      settings = {
        # General Configuration
        general = {
          renice = 0; # 0
          ioprio = 0; #
        };

        # GPU Configuration
        # gpu = {
        #   apply_gpu_optimisations = "accept-responsibility";
        #   gpu_device              = 0;
        #   amd_performance_level   = "high";
        # };

        # Custom Script Configuration
        custom = {
          start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
          end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
        };
      };
    };

    gamescope = {
      enable = true;
      capSysNice = true;
    };
  };

  environment = {
    systemPackages = with pkgs; [
      # SDL2
      # SDL2
      # SDL2_image
      # Gamemode
      gamemode
      # Vulkan
      # vkbasalt
      libnotify

      luxtorpeda
      proton-ge-custom
    ];
    # variables = {
    #   DXVK_HDR = "1";
    #   ENABLE_GAMESCOPE_WSI = "1";
    # };
  };

  chaotic.steam.extraCompatPackages = with pkgs; [
    luxtorpeda
    proton-ge-custom
  ];
}
