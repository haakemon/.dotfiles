{ config, ... }:

{
  imports = [
    ./mitmproxy.nix
  ];

  home-manager.users.${config.user-config.name} =
    { config
    , inputs
    , pkgs
    , ...
    }:
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
        pkgs.openapi-tui

        # pkgs.beekeeper-studio
        pkgs.vscode-fhs
        pkgs.meld
        pkgs.sublime-merge
        pkgs.bruno
        pkgs.simple-http-server
        pkgs.nmap
        pkgs.nodejs_24
        pkgs.pnpm
        pkgs.ffmpeg-full
        pkgs.v4l-utils
        pkgs.nixd # nix language server
        pkgs.mqtt-explorer
        pkgs.mqttui
        pkgs.posting
      ];

      home.file = {
        ".config/ghostty/config".source =
          config.lib.file.mkOutOfStoreSymlink "${config.user-config.home}/.dotfiles/ghostty/config";
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
          enableZshIntegration = true;
        };

        zsh = {
          initContent = ''
            #region initContent development.nix
            source "''${HOME}/.dotfiles/nix/devenv/nix.devenv.zsh"

            c() {
              if [ "$#" -eq 0 ]; then
                code .
              else
                code "$@"
              fi
            }

            #endregion initContent development.nix
          '';
        };
      };

    };
}
