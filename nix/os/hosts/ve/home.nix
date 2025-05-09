{ config
, lib
, pkgs
, ...
}:

{
  imports = [
    ./user-config.nix
  ];

  # Read the changelog before changing this value
  home.stateVersion = "24.05";

  home.packages = [
  ];

  home.file = {
    ".config/fastfetch/config.jsonc".source = config.lib.file.mkOutOfStoreSymlink "${config.user-config.home}/.dotfiles/fastfetch/config.jsonc";
  };

  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      history = {
        ignoreAllDups = true;
      };

      plugins = [

      ];

      initExtra = ''
        #region initContent mkBefore zsh.nix

        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
        source "''${HOME}/.dotfiles/zsh/p10k.zsh"
        source "''${HOME}/.dotfiles/zsh/p10k-extensions.zsh"
        source "''${HOME}/.dotfiles/zsh/alias.zsh"
        source "''${HOME}/.dotfiles/zsh/zsh-hooks.zsh"

        fastfetch

        #endregion initContent mkBefore zsh.nix
      '';
    };
  };
}
