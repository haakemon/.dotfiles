{ config, pkgs, lib, ... }:

{
  home = {
    username = "${config.configOptions.username}";
    homeDirectory = "${config.configOptions.userHome}";
    # enableDebugInfo = true;

    sessionVariables = {
      XDG_DESKTOP_DIR = "${config.home.homeDirectory}/Desktop";
      XDG_DOCUMENTS_DIR = "${config.home.homeDirectory}/Documents";
      XDG_DOWNLOAD_DIR = "${config.home.homeDirectory}/Downloads";
      XDG_MUSIC_DIR = "${config.home.homeDirectory}/Music";
      XDG_PICTURES_DIR = "${config.home.homeDirectory}/Pictures";
      XDG_PUBLICSHARE_DIR = "${config.home.homeDirectory}/Public";
      XDG_TEMPLATES_DIR = "${config.home.homeDirectory}/Templates";
      XDG_VIDEOS_DIR = "${config.home.homeDirectory}/Videos";

      XDG_CACHE_HOME = "${config.home.homeDirectory}/.cache";
      XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
      XDG_DATA_HOME = "${config.home.homeDirectory}/.local/share";
      XDG_STATE_HOME = "${config.home.homeDirectory}/.local/state";

      NUGET_PACKAGES = "${config.home.sessionVariables.XDG_CACHE_HOME}/NuGetPackages";
      DOTNET_CLI_HOME = "${config.home.sessionVariables.XDG_CONFIG_HOME}/.dotnet";
    };

    file = {
      ".config/nixpkgs/config.nix".text = ''
        { allowUnfree = true; }
      '';

      ".wezterm.lua".source = config.lib.file.mkOutOfStoreSymlink "${config.configOptions.userHome}/.dotfiles/wezterm/.wezterm.lua";
    };


    packages = [
      pkgs.unzip
    ] ++ lib.optionals (!config.configOptions.headless) [
      pkgs.kdenlive
      pkgs.vivaldi
      pkgs.wezterm
      pkgs.freeoffice
      pkgs.kooha # screen recorder
      pkgs.smartmontools
      (pkgs.nerdfonts.override { fonts = [ "VictorMono" ]; })
      pkgs.victor-mono
      pkgs.gparted
    ];
  };

  xdg.desktopEntries = lib.mkIf (!config.configOptions.headless) {
    vivaldi = {
      name = "Vivaldi";
      genericName = "";
      exec = "${pkgs.vivaldi}/bin/vivaldi --disable-features=AllowQt %U"; # workaround for Plasma 6 - https://github.com/NixOS/nixpkgs/pull/292148#issuecomment-1986827860
      terminal = false;
      categories = [ "Application" "Network" "WebBrowser" ];
      mimeType = [ "text/html" "text/xml" ];
      icon = "${pkgs.vivaldi}/opt/vivaldi/product_logo_256.png";
      type = "Application";
    };

    wezterm = {
      name = "WezTerm";
      genericName = "";
      exec = "${pkgs.wezterm}/bin/wezterm"; # workaround for https://github.com/wez/wezterm/issues/2933
      terminal = false;
      icon = "${pkgs.wezterm}/share/icons/hicolor/128x128/apps/org.wezfurlong.wezterm.png";
      type = "Application";
    };
  };

  # Settings for virt-manager https://nixos.wiki/wiki/Virt-manager
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };

  fonts.fontconfig.enable = true;
  nixpkgs.config.allowUnfree = true;
}
