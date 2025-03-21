{ config
, pkgs
, lib
, ...
}:
let
  gtkThemeName = "adw-gtk3-dark";
in
{
  services = lib.mkMerge [
    {
      # execute to update:
      # fwupdmgr refresh && fwupdmgr update
      fwupd.enable = true;
      dbus.implementation = "broker";
    }

    (lib.mkIf (!config.configOptions.headless) {
      gnome.gnome-keyring.enable = true;
      xserver = {
        enable = true;
        xkb.layout = "no";
      };
      pulseaudio.enable = false;
      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        socketActivation = true;
        wireplumber.enable = true;
      };
      scrutiny = {
        enable = true;
        collector.enable = true;
        settings.web.listen.port = 8999;
      };
      gvfs.enable = true; # Mount, trash, and other functionalities
      playerctld.enable = true;
    })
  ];

  xdg.icons.enable = true;
  gtk.iconCache.enable = true;

  console.keyMap = "no";
  security.rtkit.enable = true;

  hardware = {
    enableRedistributableFirmware = true;
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  };

  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nixVersions.git;
    settings = {
      use-xdg-base-directories = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
    };
    optimise.automatic = true;
  };

  environment.enableAllTerminfo = true;

  fonts.packages = lib.mkIf (!config.configOptions.headless) [
    pkgs.victor-mono
    pkgs.nerd-fonts.victor-mono
  ];

  environment.systemPackages =
    [
      pkgs.usbutils
      pkgs.pciutils
      pkgs.statix
      pkgs.nixpkgs-fmt # formatting .nix files
    ]
    ++ lib.optionals (!config.configOptions.headless) [
      pkgs.libnotify
    ];

  system = {
    autoUpgrade.enable = true;
    autoUpgrade.allowReboot = false;
  };

  programs = lib.mkMerge [
    {
      bash = {
        completion.enable = true;
      };
      dconf.enable = true;
      nix-ld.enable = true;
    }

    (lib.mkIf (!config.configOptions.headless) {
      plotinus.enable = true;
      corectrl.enable = true;
    })
  ];

  time.timeZone = "Europe/Oslo";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_CTYPE = "en_US.UTF-8";
      LC_COLLATE = "en_US.UTF-8";
      LC_MESSAGES = "en_US.UTF-8";

      LC_ADDRESS = "nb_NO.UTF-8";
      LC_IDENTIFICATION = "nb_NO.UTF-8";
      LC_MEASUREMENT = "nb_NO.UTF-8";
      LC_MONETARY = "nb_NO.UTF-8";
      LC_NAME = "nb_NO.UTF-8";
      LC_NUMERIC = "nb_NO.UTF-8";
      LC_PAPER = "nb_NO.UTF-8";
      LC_TELEPHONE = "nb_NO.UTF-8";
      LC_TIME = "nb_NO.UTF-8";
    };
  };

  home-manager.users.${config.configOptions.username} =
    { config
    , pkgs
    , lib
    , ...
    }:
    {
      programs.home-manager.enable = true;
      home = {
        # This value determines the Home Manager release that your configuration is
        # compatible with. This helps avoid breakage when a new Home Manager release
        # introduces backwards incompatible changes.
        #
        # You should not change this value, even if you update Home Manager. If you do
        # want to update the value, then make sure to first check the Home Manager
        # release notes.
        stateVersion = "24.05"; # Please read the comment before changing.

        username = "${config.configOptions.username}";
        homeDirectory = "${config.configOptions.userHome}";

        sessionVariables = {
          # https://wiki.archlinux.org/title/XDG_Base_Directory
          XDG_DESKTOP_DIR = "${config.home.homeDirectory}/Desktop";
          XDG_DOCUMENTS_DIR = "${config.home.homeDirectory}/Documents";
          XDG_DOWNLOAD_DIR = "${config.home.homeDirectory}/Downloads";
          XDG_MUSIC_DIR = "${config.home.homeDirectory}/Music";
          XDG_PICTURES_DIR = "${config.home.homeDirectory}/Pictures";
          XDG_PUBLICSHARE_DIR = "${config.home.homeDirectory}/Public";
          XDG_TEMPLATES_DIR = "${config.home.homeDirectory}/Templates";
          XDG_VIDEOS_DIR = "${config.home.homeDirectory}/Videos";

          XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
          XDG_CACHE_HOME = "${config.home.homeDirectory}/.cache";
          XDG_DATA_HOME = "${config.home.homeDirectory}/.local/share";
          XDG_STATE_HOME = "${config.home.homeDirectory}/.local/state";

          DOTNET_CLI_HOME = "${config.home.sessionVariables.XDG_CONFIG_HOME}/.dotnet";
          NPM_CONFIG_USERCONFIG = "${config.home.sessionVariables.XDG_CONFIG_HOME}/npm/config";
          AZURE_CONFIG_DIR = "${config.home.sessionVariables.XDG_CONFIG_HOME}/azure";
          FLY_CONFIG_DIR = "${config.home.sessionVariables.XDG_CONFIG_HOME}/fly";

          NUGET_PACKAGES = "${config.home.sessionVariables.XDG_CACHE_HOME}/NuGetPackages";
          CARGO_HOME = "${config.home.sessionVariables.XDG_CACHE_HOME}/cargo";
          DVDCSS_CACHE = "${config.home.sessionVariables.XDG_CACHE_HOME}/dvdcss";
          NPM_CONFIG_CACHE = "${config.home.sessionVariables.XDG_CACHE_HOME}/npm_cache";
          NPM_CONFIG_TMP = "${config.home.sessionVariables.XDG_CACHE_HOME}/npm_tmp";
          AZURE_LOGGING_LOG_DIR = "${config.home.sessionVariables.XDG_CACHE_HOME}/azure/logs";

          RUSTUP_HOME = "${config.home.sessionVariables.XDG_DATA_HOME}/rustup";
          GNUPGHOME = "${config.home.sessionVariables.XDG_DATA_HOME}/gnupg";

          DISPLAY = ":0";
          GTK_THEME = gtkThemeName;
          NODE_REPL_HISTORY = ""; # Disable node repl persistent history
          XCURSOR_PATH = "${config.home.sessionVariables.XDG_DATA_HOME}/icons";

          STEAM_EXTRA_COMPAT_TOOLS_PATHS = "${config.home.homeDirectory}/.steam/root/compatibilitytools.d";
          # ELECTRON_OZONE_PLATFORM_HINT = "auto"; # or  "wayland" ? # breaks vivaldi even with workaround in plasma?
          # NIXOS_OZONE_WL = "1"; # do I still need this? # breaks vscode in plasma?
        };

        sessionPath = [
          "${config.home.homeDirectory}/.local/bin"
        ];

        file = {
          ".config/nixpkgs/config.nix".text = ''
            { allowUnfree = true; }
          '';
          ".config/zed/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${config.configOptions.userHome}/.dotfiles/zed/settings.json";
          ".config/zed/keymap.json".source = config.lib.file.mkOutOfStoreSymlink "${config.configOptions.userHome}/.dotfiles/zed/keymap.json";

          "${config.home.sessionVariables.XDG_DATA_HOME}/icons/Banana".source =
            config.lib.file.mkOutOfStoreSymlink "${pkgs.banana-cursor}/share/icons/Banana";
          "${config.home.sessionVariables.XDG_DATA_HOME}/icons/Dracula".source =
            config.lib.file.mkOutOfStoreSymlink "${pkgs.dracula-icon-theme}/share/icons/Dracula";

          ".face.icon".source = config.lib.file.mkOutOfStoreSymlink "${config.configOptions.userHome}/.dotfiles/sddm/.face.icon";
        };

        packages =
          [
            pkgs.systemctl-tui
            pkgs.lazyjournal # journalctl tool
            pkgs.podman-tui

            pkgs.bandwhich # network utilization monitor
            pkgs.dblab # db client
            pkgs.superfile
            pkgs.television # multi-purpose fuzzy finder
            pkgs.bluetui
            pkgs.pavucontrol # sound

            pkgs.rclone
            pkgs.unzip
            pkgs.croc
            (
              let
                base = pkgs.appimageTools.defaultFhsEnvArgs;
              in
              pkgs.buildFHSEnv (
                base
                // {
                  name = "fhs";
                  targetPkgs = pkgs: (base.targetPkgs pkgs) ++ [ pkgs.pkg-config ];
                  profile = "export FHS=1";
                  runScript = "zsh";
                  extraOutputsToInstall = [ "dev" ];
                }
              )
            )
          ]
          ++ lib.optionals (!config.configOptions.headless) [
            pkgs.proton-pass
            pkgs.bitwarden-desktop
            pkgs.keepassxc
            pkgs.protonvpn-gui
            pkgs.xorg.xwininfo

            pkgs.spotify
            pkgs.spotify-player # tui
            pkgs.vlc

            pkgs.cosmic-files

            # pkgs.openshot-qt
            # pkgs.shotcut

            # pkgs.freeoffice
            pkgs.smartmontools
            pkgs.gparted
            pkgs.standardnotes
            # pkgs.manuskript
            # pkgs.rawtherapee
            # pkgs.peazip # https://nixpk.gs/pr-tracker.html?pr=374566
            pkgs.nix-tree
            pkgs.nomacs # image viewer
            pkgs.marktext
            pkgs.scrcpy
            # pkgs.krusader
            # pkgs.grim # screenshot tool
            # pkgs.fuzzel
          ];

      };
      dconf.settings = lib.mkIf (!config.configOptions.headless) {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
        };
      };

      fonts.fontconfig.enable = true;

      gtk = {
        enable = true;
        theme = {
          name = gtkThemeName;
          package = pkgs.adw-gtk3;
        };
        iconTheme = {
          name = "Dracula";
          package = pkgs.dracula-icon-theme;
        };
        cursorTheme = {
          name = "Banana";
          size = 36;
          package = pkgs.banana-cursor;
        };

        # gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
        # gtk2.extraConfig = "gtk-application-prefer-dark-theme = 1";

        gtk3.extraConfig = {
          gtk-application-prefer-dark-theme = 1;
        };

        gtk4.extraConfig = {
          gtk-application-prefer-dark-theme = 1;
        };
      };
    };
}
