{ config, pkgs, ... }:

{
  imports =
    [
      ../../common/home/base.nix
      ../../common/home/git.nix
      ../../common/home/security.nix
      ../../common/home/zsh.nix
      # ../../common/home/development.nix
    ];

  programs = {
    home-manager.enable = true;
  };

  home = {
    packages = [
      # Utils
      pkgs.jotta-cli

      (
        let base = pkgs.appimageTools.defaultFhsEnvArgs; in
        pkgs.buildFHSUserEnv (base // {
          name = "fhs";
          targetPkgs = pkgs: (base.targetPkgs pkgs) ++ [ pkgs.pkg-config ];
          profile = "export FHS=1";
          runScript = "zsh";
          extraOutputsToInstall = [ "dev" ];
        })
      )
    ];

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    stateVersion = "24.05"; # Please read the comment before changing.
  };
}
