{ config, ... }:

{
  home-manager.users.${config.configOptions.username} =
    { config
    , pkgs
    , lib
    , ...
    }:
    {
      home.packages = [
        # Browsers
        pkgs.firefox
        pkgs.ungoogled-chromium

        # Terminals
        pkgs.alacritty
        pkgs.cosmic-term
        pkgs.vhs # terminal gifs

        # Tools
        pkgs.vscode-fhs
        pkgs.meld
        pkgs.sublime-merge
        pkgs.bruno
        pkgs.mitmproxy
        pkgs.simple-http-server
        pkgs.nmap
        pkgs.nodejs
        pkgs.corepack
        pkgs.ffmpeg
        pkgs.nixd # nix language server
        # pkgs.flyctl
        # pkgs.arduino-ide
        # pkgs.android-studio
      ];

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
    };
}
