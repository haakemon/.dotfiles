{ inputs, config, pkgs, ... }:

{
  imports =
    [
      inputs.ags.homeManagerModules.default

      ../../common/home/base.nix
      ../../common/home/git.nix
      ../../common/home/security.nix
      ../../common/home/zsh.nix
      ../../common/home/development.nix
    ];


  programs = {
    home-manager.enable = true;
    niri.config = null;

    ags = {
      enable = true;

      # null or path, leave as null if you don't want hm to manage the config
      #configDir = ../ags;
      configDir = null;

      # additional packages to add to gjs's runtime
      extraPackages = [
        pkgs.gtksourceview
        pkgs.webkitgtk
        pkgs.accountsservice
        pkgs.gvfs
      ];
    };

    wlogout = {
      enable = true;
      layout = [
        {
          label = "shutdown";
          action = "systemctl poweroff";
          text = "Shutdown";
          keybind = "s";
        }
        {
          label = "reboot";
          action = "systemctl reboot";
          text = "Reboot";
          keybind = "r";
        }
        {
          label = "logout";
          action = "sleep 1; niri msg action quit";
          text = "Logout";
          keybind = "l";
        }
      ];
    };


    swaylock = {
      enable = true;
      package = pkgs.swaylock-effects;
      settings = {
        clock = true;
        #color = "00000000";
        show-failed-attempts = true;
        indicator = true;
        indicator-radius = 220;
        indicator-thickness = 25;
        # line-color = "#${background}";
        # ring-color = "${mbg}";
        # inside-color = "#${background}";
        # key-hl-color = "#${accent}";
        # separator-color = "00000000";
        # text-color = "#${foreground}";
        # text-caps-lock-color = "";
        # line-ver-color = "#${accent}";
        # ring-ver-color = "#${accent}";
        # inside-ver-color = "#${background}";
        # text-ver-color = "#${foreground}";
        # ring-wrong-color = "#${color9}";
        # text-wrong-color = "#${color9}";
        # inside-wrong-color = "#${background}";
        # inside-clear-color = "#${background}";
        # text-clear-color = "#${foreground}";
        # ring-clear-color = "#${color5}";
        # line-clear-color = "#${background}";
        # line-wrong-color = "#${background}";
        # bs-hl-color = "#${accent}";
        line-uses-ring = false;
        grace = 8;
        #datestr = "%d.%m";
        fade-in = ".500";
        ignore-empty-password = true;
        screenshots = true;
        effect-blur = "6x6";
        font = "Victor Mono";
        effect-greyscale = true;

      };
    };

    #   programs.wezterm = {
    #   enable = true;
    #   colorSchemes = import ./colors.nix {
    #     inherit colors;
    #   };
    #   package = inputs.nixpkgs-f2k.packages.${pkgs.system}.wezterm-git;
    #   extraConfig = ''
    #     local wez = require('wezterm')
    #     return {
    #       default_prog     = { 'zsh' },
    #       cell_width = 0.85,
    #       -- Performance
    #       --------------
    #       front_end        = "WebGpu",
    #       enable_wayland   = true,
    #       scrollback_lines = 1024,
    #       -- Fonts
    #       --------
    #       font         = wez.font_with_fallback({
    #         "Iosevka Nerd Font",
    #         "Material Design Icons",
    #       }),
    #       initial_rows = 18,
    #       initial_cols = 85,
    #       dpi = 96.0,
    #       bold_brightens_ansi_colors = true,
    #       font_rules    = {
    #         {
    #           italic = true,
    #           font   = wez.font("Iosevka Nerd Font", { italic = true })
    #         }
    #       },
    #       --font_antialias = "Subpixel",
    #       --font_hinting = "VerticalSubpixel",
    #       font_size         = 14.0,
    #       line_height       = 1.15,
    #       harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' },
    #       -- Bling
    #       --------
    #       color_scheme   = "followSystem",
    #       window_padding = {
    #         left = "32pt", right = "32pt",
    #         bottom = "32pt", top = "32pt"
    #       },
    #       default_cursor_style = "SteadyUnderline",
    #       enable_scroll_bar    = false,
    #       warn_about_missing_glyphs = false,
    #       -- Tabbar
    #       ---------
    #       enable_tab_bar               = true,
    #       use_fancy_tab_bar            = false,
    #       hide_tab_bar_if_only_one_tab = true,
    #       show_tab_index_in_tab_bar    = false,
    #       -- Miscelaneous
    #       ---------------
    #       window_close_confirmation = "NeverPrompt",
    #       inactive_pane_hsb         = {
    #         saturation = 1.0, brightness = 0.8
    #       },
    #       check_for_updates = false,
    #       window_background_opacity = 1
    #     }
    #   '';
    # };


  };

  services = {
    swayidle = {
      enable = true;
      events = [
        { event = "before-sleep"; command = "${pkgs.swaylock-effects}/bin/swaylock -f"; }
        { event = "lock"; command = "lock"; }
      ];
      timeouts = [
        { timeout = 300; command = "${pkgs.niri}/bin/niri msg action power-off-monitors"; }
        { timeout = 3600; command = "${pkgs.swaylock-effects}/bin/swaylock -f"; }
        { timeout = 7200; command = "${pkgs.systemd}/bin/systemctl suspend"; }
      ];
    };
  };

  home = {
    packages = [
      # Utils
      pkgs.jotta-cli
      pkgs.headsetcontrol # Set options for headsets

      # Tools
      # pkgs.blender
      pkgs.obs-studio
      pkgs.prusa-slicer
      pkgs.plasticity
      # pkgs.gitbutler

      # Gaming
      pkgs.heroic

      # Music / video
      pkgs.spotify
      pkgs.freetube
      pkgs.vlc

      # Chat
      pkgs.telegram-desktop
      pkgs.vesktop

      (
        let base = pkgs.appimageTools.defaultFhsEnvArgs; in
        pkgs.buildFHSUserEnv (base // {
          name = "fhs";
          targetPkgs = pkgs: (base.targetPkgs pkgs) ++ [ pkgs.pkg-config ];
          profile = "export FHS=1";
          runScript = "zsh";
          extraOutputsToInstall = [ "dev" ];
        })
      )
    ];

    file = {
      ".face.icon".source = config.lib.file.mkOutOfStoreSymlink "${config.configOptions.userHome}/.dotfiles/sddm/.face.icon";
      ".config/niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "${config.configOptions.userHome}/.dotfiles/niri/config.kdl";
    };

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    stateVersion = "24.05"; # Please read the comment before changing.
  };
}
