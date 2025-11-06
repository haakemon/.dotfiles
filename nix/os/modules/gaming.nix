{ pkgs, ... }:

{
  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      gamescopeSession.enable = true;
      localNetworkGameTransfers.openFirewall = true;
      package = pkgs.steam.override {
        extraPkgs =
          pkgs: with pkgs; [
            libkrb5
            keyutils
          ];
      };
      extraCompatPackages = [
        pkgs.luxtorpeda
        pkgs.proton-ge-custom
      ];
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
          ioprio = 0;
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
    systemPackages = [
      pkgs.SDL2
      pkgs.SDL2
      pkgs.SDL2_image
      pkgs.vkbasalt
      pkgs.libnotify

      pkgs.luxtorpeda
      pkgs.proton-ge-custom
      pkgs.protonup-ng
      pkgs.protonup-qt
      pkgs.mangohud

      pkgs.heroic
      pkgs.vesktop
      pkgs.discord

      # games
      # pkgs.mari0
      # pkgs.pingus
      # pkgs.openrw
      # pkgs.openra https://github.com/NixOS/nixpkgs/issues/360335#issuecomment-2513069288
      # pkgs.airshipper # https://www.veloren.net/
      # pkgs.superTuxKart
      # pkgs.openrct2
      # pkgs.simutrans
      # pkgs.widelands
    ];
    variables = {
      DXVK_HDR = "1";
      ENABLE_GAMESCOPE_WSI = "1";
    };
  };
}
