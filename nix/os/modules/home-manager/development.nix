{ config, pkgs, ... }:

{
  home.packages = [
    # Browsers
    pkgs.firefox
    pkgs.ungoogled-chromium

    # Tools
    # pkgs.mqttmultimeter # broken?
    pkgs.vhs
    # pkgs.vscode
    pkgs.vscode-fhs
    pkgs.wezterm
    pkgs.bruno
    pkgs.sublime-merge
    pkgs.meld
    pkgs.gh # github cli
    pkgs.simple-http-server
    pkgs.zettlr
    pkgs.libsForQt5.kruler
    pkgs.kooha # screen recorder
    pkgs.orca # screen reader
    pkgs.ffmpeg
    pkgs.flyctl
    pkgs.beekeeper-studio
    pkgs.pre-commit
    pkgs.gcc # requirement for pre-commit nixpkgs-fmt
    pkgs.rustup # requirement for pre-commit nixpkgs-fmt
    pkgs.nodejs
    pkgs.corepack
    pkgs.nmap
    pkgs.termius
    pkgs.mitmproxy
    pkgs.arduino-ide
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
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

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
