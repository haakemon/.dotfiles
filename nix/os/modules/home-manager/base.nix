{ config, pkgs, lib, ... }:
let
  cus_vivaldi = pkgs.vivaldi.overrideAttrs
    (oldAttrs: {
      dontWrapQtApps = false;
      dontPatchELF = true;
      nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ pkgs.kdePackages.wrapQtAppsHook ];
    });
in
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

      DOTNET_CLI_HOME = "${config.home.sessionVariables.XDG_CONFIG_HOME}/.dotnet";
      NPM_CONFIG_USERCONFIG = "${config.home.sessionVariables.XDG_CONFIG_HOME}/npm/config";

      NUGET_PACKAGES = "${config.home.sessionVariables.XDG_CACHE_HOME}/NuGetPackages";
      CARGO_HOME = "${config.home.sessionVariables.XDG_CACHE_HOME}/cargo";
      DVDCSS_CACHE = "${config.home.sessionVariables.XDG_CACHE_HOME}/dvdcss";
      NPM_CONFIG_CACHE = "${config.home.sessionVariables.XDG_CACHE_HOME}/npm_cache";
      NPM_CONFIG_TMP = "${config.home.sessionVariables.XDG_CACHE_HOME}/npm_tmp";

      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "${config.home.homeDirectory}/.steam/root/compatibilitytools.d";
      # ELECTRON_OZONE_PLATFORM_HINT = "auto"; # or  "wayland" ? # breaks vivaldi even with workaround in plasma?
      # NIXOS_OZONE_WL = 1; # do I still need this? # breaks vscode in plasma?
    };

    file = {
      ".config/nixpkgs/config.nix".text = ''
        { allowUnfree = true; }
      '';
    };


    packages = [
      pkgs.unzip
      pkgs.croc
    ] ++ lib.optionals (!config.configOptions.headless) [
      pkgs.openshot-qt
      pkgs.shotcut
      # pkgs.vivaldi

      cus_vivaldi
      pkgs.wezterm
      pkgs.freeoffice
      pkgs.kooha # screen recorder
      pkgs.smartmontools
      (pkgs.nerdfonts.override { fonts = [ "VictorMono" ]; })
      pkgs.victor-mono
      pkgs.gparted
      pkgs.standardnotes
      pkgs.manuskript
      pkgs.rawtherapee
      pkgs.nomacs # image viewer
      pkgs.marktext
      pkgs.scrcpy
      pkgs.slides # terminal markdown slides
      pkgs.krusader
      pkgs.grim # screenshot tool
      pkgs.fuzzel
    ];
  };

  # Settings for virt-manager https://nixos.wiki/wiki/Virt-manager
  dconf.settings = lib.mkIf (!config.configOptions.headless) {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };

  fonts.fontconfig.enable = true;
  nixpkgs.config.allowUnfree = true;
}
