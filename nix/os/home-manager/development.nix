{ config, pkgs, ... }:
let
  inherit (import ../options.nix)
    gitUsername
    gitEmail
    userHome;
in
{
  home.packages = with pkgs; [
    # Browsers
    firefox
    ungoogled-chromium

    # Tools
    mqttmultimeter
    vscode
    notepadqq
    wezterm
    bruno
    sublime-merge
  ];

  home.file = {
    ".wezterm.lua".source = config.lib.file.mkOutOfStoreSymlink "${userHome}/.dotfiles/wezterm/.wezterm.lua";
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
    git = {
      enable = true;
      delta = {
        enable = true;
      };
      extraConfig = {
        user = {
          name = "${gitUsername}";
          email = "${gitEmail}";
        };
      };
      includes = [
        { path = "~/.dotfiles/git/.gitconfig-alias"; }
        { path = "~/.dotfiles/git/.gitconfig-color"; }
        { path = "~/.dotfiles/git/.gitconfig-settings"; }
        { path = "~/.dotfiles/git/.gitconfig-signing"; }
      ];
    };

    zsh = {
      initExtra = ''
        #region development initExtra
        source "''${HOME}/.dotfiles/nix/devenv/nix.devenv.zsh"
        #endregion development initExtra
      '';
    };
  };
}
