{ config
, pkgs
, lib
, ...
}:

{
  home = {
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

      pkgs.signal-desktop

      # pkgs.openshot-qt
      # pkgs.shotcut

      pkgs.hardinfo2
      pkgs.smartmontools
      pkgs.gparted
      pkgs.standardnotes
      # pkgs.manuskript
      # pkgs.rawtherapee
      # pkgs.peazip # https://nixpk.gs/pr-tracker.html?pr=374566
      pkgs.nix-tree
      pkgs.nomacs # image viewer
      pkgs.scrcpy
      pkgs.clipse
      pkgs.emote

      pkgs.victor-mono
      pkgs.nerd-fonts.victor-mono
      pkgs.noto-fonts
      pkgs.noto-fonts-color-emoji
      pkgs.noto-fonts-cjk-sans
      pkgs.noto-fonts-cjk-serif
    ];
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
  };

  fonts.fontconfig.enable = true;
}
