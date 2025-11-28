{ config
, pkgs
, lib
, ...
}:
let
  gtkThemeName = "adw-gtk3-dark";
in
{
  services = {
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
    gvfs.enable = true; # Mount, trash, and other functionalities
    playerctld.enable = true;
  };

  xdg.icons.enable = true;
  gtk.iconCache.enable = true;

  hardware = {
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  };

  fonts.packages = [
    pkgs.victor-mono
    pkgs.nerd-fonts.victor-mono
    pkgs.fira-sans
    pkgs.roboto
    pkgs.nerd-fonts._0xproto
    pkgs.nerd-fonts.droid-sans-mono
    pkgs.jetbrains-mono
    pkgs.noto-fonts
    pkgs.noto-fonts-color-emoji
    pkgs.noto-fonts-cjk-sans
    pkgs.noto-fonts-cjk-serif
    pkgs.material-symbols
    pkgs.material-icons
  ];

  environment.systemPackages = [
    pkgs.usbutils
    pkgs.pciutils
    pkgs.statix
    pkgs.nixpkgs-fmt # formatting .nix files
    pkgs.libnotify
  ];

  home-manager.users.${config.user-config.name} =
    { config
    , pkgs
    , lib
    , ...
    }:
    {

      home = {
        # This value determines the Home Manager release that your configuration is
        # compatible with. This helps avoid breakage when a new Home Manager release
        # introduces backwards incompatible changes.
        #
        # You should not change this value, even if you update Home Manager. If you do
        # want to update the value, then make sure to first check the Home Manager
        # release notes.
        stateVersion = "24.05"; # Please read the comment before changing.

        sessionVariables = {
          DISPLAY = ":0";
          GTK_THEME = gtkThemeName;
          XCURSOR_PATH = "${config.home.sessionVariables.XDG_DATA_HOME}/icons";

          STEAM_EXTRA_COMPAT_TOOLS_PATHS = "${config.home.homeDirectory}/.steam/root/compatibilitytools.d";
          # ELECTRON_OZONE_PLATFORM_HINT = "auto"; # or  "wayland" ? # breaks vivaldi even with workaround in plasma?
          # NIXOS_OZONE_WL = "1"; # do I still need this? # breaks vscode in plasma?
        };

        file = {
          ".config/zed/settings.json".source =
            config.lib.file.mkOutOfStoreSymlink "${config.user-config.home}/.dotfiles/zed/settings.json";
          ".config/zed/keymap.json".source =
            config.lib.file.mkOutOfStoreSymlink "${config.user-config.home}/.dotfiles/zed/keymap.json";
          ".config/spotify-player/keymap.toml".source =
            config.lib.file.mkOutOfStoreSymlink "${config.user-config.home}/.dotfiles/spotify-player/keymap.toml";
          ".config/spotify-player/app.toml".source =
            config.lib.file.mkOutOfStoreSymlink "${config.user-config.home}/.dotfiles/spotify-player/app.toml";

          "${config.home.sessionVariables.XDG_DATA_HOME}/icons/Banana".source =
            config.lib.file.mkOutOfStoreSymlink "${pkgs.banana-cursor}/share/icons/Banana";
          "${config.home.sessionVariables.XDG_DATA_HOME}/icons/Dracula".source =
            config.lib.file.mkOutOfStoreSymlink "${pkgs.dracula-icon-theme}/share/icons/Dracula";

          ".face.icon".source =
            config.lib.file.mkOutOfStoreSymlink "${config.user-config.home}/.dotfiles/sddm/.face.icon";
        };

        packages = [
          pkgs.bluetui
          pkgs.pavucontrol # sound

          pkgs.proton-pass
          pkgs.bitwarden-desktop
          pkgs.keepassxc
          pkgs.protonvpn-gui
          pkgs.xorg.xwininfo
          pkgs.mission-center # taskmanager

          pkgs.spotify
          pkgs.spotify-player # tui
          pkgs.vlc

          pkgs.cosmic-files
          pkgs.filen-desktop

          # pkgs.openshot-qt
          # pkgs.shotcut

          # pkgs.freeoffice
          pkgs.hardinfo2
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
      dconf.settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
        };
      };

      fonts.fontconfig.enable = true;
      fonts.fontDir.enable = true;

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
