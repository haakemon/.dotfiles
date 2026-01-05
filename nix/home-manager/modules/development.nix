{ config, pkgs, inputs, ... }:

{

  home.packages = [
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

    pkgs.mqtt-explorer
    pkgs.posting

    pkgs.dive # explore docker layers
    pkgs.podman-tui
  ];

  home.file = {
    ".config/ghostty/config".source =
      config.lib.file.mkOutOfStoreSymlink "${config.user-config.home}/.dotfiles/ghostty/config";
  };

}
