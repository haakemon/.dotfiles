{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Password management
    keychain
    bitwarden
    rbw # https://crates.io/crates/rbw unofficial bitwarden CLI
    pinentry # dependency for rbw
    keepassxc

    # Tools
    protonvpn-gui
  ];

  programs = {
    home-manager.enable = true;
    zsh = {
      initExtra = ''
        #region auth initExtra
        source "''${HOME}/.dotfiles/zsh/ssh.zsh"
        #endregion auth initExtra
      '';
    };
  };
}
