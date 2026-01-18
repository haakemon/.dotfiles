{ config, pkgs, inputs, ... }:

{

  home = {
    packages = [
      # Terminals
      pkgs.alacritty
      pkgs.cosmic-term
      inputs.ghostty.packages.x86_64-linux.default
      pkgs.vhs # terminal gifs

      # Tools
      # inputs.zeditor.packages."x86_64-linux".default
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
  };

  programs = {
    zsh = {
      shellAliases = {
        mitmproxy = "mitmproxy --set confdir=${config.home.sessionVariables.XDG_CONFIG_HOME}/mitmproxy";
        mitmweb = "mitmweb --set confdir=${config.home.sessionVariables.XDG_CONFIG_HOME}/mitmproxy";
      };
    };
  };

  sessionVariables = {
    QMK_HOME = "${config.home.homeDirectory}/code/qmk_firmware";
  };
}
