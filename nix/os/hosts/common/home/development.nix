{ config, pkgs, ... }:

{
  home.packages = [
    # Browsers
    pkgs.firefox
    pkgs.ungoogled-chromium

    # Tools
    pkgs.mqttmultimeter
    # pkgs.vscode
    pkgs.vscode-fhs
    pkgs.wezterm
    pkgs.bruno
    pkgs.sublime-merge
    pkgs.gh # github cli
    pkgs.simple-http-server
    pkgs.zettlr
    pkgs.libsForQt5.kruler
    pkgs.kooha # screen recorder
    pkgs.orca # screen reader
    pkgs.ffmpeg
    pkgs.kdePackages.kcolorchooser
    pkgs.flyctl
    pkgs.beekeeper-studio
    # pkgs.android-studio
  ];

  home.file = {
    ".wezterm.lua".source = config.lib.file.mkOutOfStoreSymlink "${config.configOptions.userHome}/.dotfiles/wezterm/.wezterm.lua";
  };

  editorconfig = {
    enable = true;
    settings = {
      "*" = {
        charset = "utf-8";
        end_of_line = "lf";
        insert_final_newline = true;
        trim_trailing_whitespace = true;
        indent_size = 2;
        max_line_width = 85;
        indent_style = "space";
      };

      "*.md" = {
        trim_trailing_whitespace = false;
      };
    };
  };

  programs = {
    home-manager.enable = true;
    direnv.enable = true;

    zsh = {
      initExtra = ''
        #region development initExtra
        source "''${HOME}/.dotfiles/nix/devenv/nix.devenv.zsh"

        c() {
          if [ "$#" -eq 0 ]; then
            code .
          else
            code "$@"
          fi
        }

        #endregion development initExtra
      '';
    };
  };
}
