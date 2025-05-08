{ config
, lib
, pkgs
, ...
}:

{
  # Read the changelog before changing this value
  home.stateVersion = "24.05";

  home.packages = [
  ];

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

      initContent = lib.mkBefore ''
        #region initContent mkBefore zsh.nix

        fastfetch

        #endregion initContent mkBefore zsh.nix
      '';
    };
  };
}
