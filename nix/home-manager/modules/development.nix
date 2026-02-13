{ config, pkgs, inputs, ... }:

{

  home = {
    packages = [
      # Terminals
      # pkgs.alacritty
      pkgs.cosmic-term
      pkgs.vhs # terminal gifs

      # Tools
      pkgs.zed-editor
      # pkgs.openapi-tui

      # pkgs.beekeeper-studio
      pkgs.vscode-fhs
      pkgs.meld
      pkgs.sublime-merge
      # pkgs.bruno
      pkgs.qmk

      pkgs.mqtt-explorer
      pkgs.posting
      pkgs.mitmproxy

      pkgs.dive # explore docker layers
      pkgs.podman-tui
    ];

    file = {
      ".config/ghostty/config".source =
        config.lib.file.mkOutOfStoreSymlink "${config.user-config.home}/.dotfiles/ghostty/config";
    };

    sessionVariables = {
      QMK_HOME = "${config.home.homeDirectory}/code/qmk_firmware";
    };
  };

  programs = {
    ghostty = {
      enable = true;
      enableZshIntegration = true;
      systemd.enable = true;
    };
  };
}
