{ inputs
, config
, pkgs
, ...
}:
{
  imports = [
    ../../modules/base.nix
    ../../modules/base_headfull.nix
    ../../modules/browsers.nix
    ../../modules/development.nix
    ../../modules/hypridle.nix
    ../../modules/hyprlock.nix
    ../../modules/mitmproxy.nix
    ../../modules/noctalia.nix
    ../../modules/obs-studio.nix
    ../../modules/qmk.nix
    ../../modules/zsh.nix
    ../../modules/niri.nix
  ];

  home = {
    stateVersion = "24.05";
    username = config.user-config.name;
    homeDirectory = config.user-config.home;

    packages = [
      # Utils
      pkgs.headsetcontrol # Set options for headsets
      pkgs.gcalcli

      # Music / video
      pkgs.freetube

      # Devtools
      pkgs.azure-cli
      pkgs.kubectl
      pkgs.kubelogin
      pkgs.kubectx
      pkgs.k9s
      pkgs.vault
      pkgs.dotnet-sdk_9
      pkgs.traefik
      pkgs.claude-code

      # Chat
      pkgs.telegram-desktop
      pkgs.slack
    ];

    file = {
      ".config/noctalia/colors.json".source =
        config.lib.file.mkOutOfStoreSymlink "${config.user-config.home}/.dotfiles/quickshell/noctalia/delling/colors.json";
      ".config/noctalia/gui-settings.json".source =
        config.lib.file.mkOutOfStoreSymlink "${config.user-config.home}/.dotfiles/quickshell/noctalia/delling/gui-settings.json";
      ".config/noctalia/settings.json".source =
        config.lib.file.mkOutOfStoreSymlink "${config.user-config.home}/.dotfiles/quickshell/noctalia/delling/settings.json";
    };
  };

  programs = {
    zsh = {
      initContent = ''
        #region initContent configuration.nix
        source "''${HOME}/work/configs/env.zsh"
        #endregion initContent configuration.nix
      '';
    };

    hyprlock = {
      settings = {
        auth = {
          "fingerprint:enabled" = true;
        };
      };
    };
  };

  browsers = {
    vivaldi = true;
    firefox = true;
    chromium = true;
    ladybird = true;
    zen = true;
    browsers = true;
    google-chrome = true;
  };

}
