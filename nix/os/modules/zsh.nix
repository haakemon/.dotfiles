{ config, pkgs, lib, ... }:

{
  programs = {
    zsh = {
      enable = true;
      enableBashCompletion = true;
    };
    fzf = {
      fuzzyCompletion = true;
      keybindings = true;
    };
  };

  home-manager.users.${config.configOptions.username} = { config, pkgs, ... }: {
    home.packages = [
      pkgs.killall
      pkgs.wget
      pkgs.fastfetch
      pkgs.eza
      pkgs.zsh-powerlevel10k
      pkgs.entr # https://github.com/eradman/entr
      (pkgs.nerdfonts.override { fonts = [ "VictorMono" ]; })
      pkgs.victor-mono
      pkgs.bat
      pkgs.fzf # fuzzy find
      pkgs.grc # generic text colorizer
      pkgs.jq
      pkgs.zoxide
      pkgs.fd
      pkgs.ripgrep
      pkgs.onefetch # fastfetch for git repos
      pkgs.navi
      pkgs.duf # disk space utility
      pkgs.glow # cli markdown viewer
      pkgs.glances
      pkgs.clipboard-jh # https://github.com/Slackadays/Clipboard
    ];

    home.file = {
      ".config/fastfetch/config.jsonc".source = config.lib.file.mkOutOfStoreSymlink "${config.configOptions.userHome}/.dotfiles/fastfetch/config.jsonc";
    };

    programs = {
      zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;

        history = {
          ignoreAllDups = true;
          path = "${config.configOptions.userHome}/.local/share/zsh/zsh_history";
        };
        dirHashes = {
          code = "${config.configOptions.userHome}/code";
          dl = "${config.configOptions.userHome}/Downloads";
          dots = "${config.configOptions.userHome}/.dotfiles";
          flake = "${config.configOptions.flake.dir}";
        };
        dotDir = ".config/zsh";

        plugins = [
          {
            name = "zsh-autosuggestions";
            src = pkgs.fetchFromGitHub {
              owner = "zsh-users";
              repo = "zsh-autosuggestions";
              rev = "v0.7.0";
              hash = "sha256-KLUYpUu4DHRumQZ3w59m9aTW6TBKMCXl2UcKi4uMd7w=";
            };
          }
          {
            name = "zsh-syntax-highlighting";
            file = "zsh-syntax-highlighting.zsh";
            src = pkgs.fetchFromGitHub {
              owner = "zsh-users";
              repo = "zsh-syntax-highlighting";
              rev = "0.7.1";
              hash = "sha256-gOG0NLlaJfotJfs+SUhGgLTNOnGLjoqnUp54V9aFJg8=";
            };
          }
          {
            name = "zsh-fzf-history-search";
            file = "zsh-fzf-history-search.zsh";
            src = pkgs.fetchFromGitHub {
              owner = "joshskidmore";
              repo = "zsh-fzf-history-search";
              rev = "d1aae98ccd6ce153c97a5401d79fd36418cd2958";
              hash = "sha256-4Dp2ehZLO83NhdBOKV0BhYFIvieaZPqiZZZtxsXWRaQ=";
            };
          }
          {
            name = "zsh-npm-scripts-autocomplete";
            file = "zsh-npm-scripts-autocomplete.plugin.zsh";
            src = pkgs.fetchFromGitHub {
              owner = "grigorii-zander";
              repo = "zsh-npm-scripts-autocomplete";
              rev = "5d145e13150acf5dbb01dac6e57e57c357a47a4b";
              hash = "sha256-Y34VXOU7b5z+R2SssCmbooVwrlmSxUxkObTV0YtsS50=";
            };
          }
        ];

        initExtraFirst = ''
          #region initExtraFirst
          autoload -Uz compinit
          compinit
          unsetopt beep

          eval "$(zoxide init --cmd cd zsh)"

          # better fd
          export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
          export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
          export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

          # Use fd (https://github.com/sharkdp/fd) for listing path candidates.
          # - The first argument to the function ($1) is the base path to start traversal
          # - See the source code (completion.{bash,zsh}) for the details.
          _fzf_compgen_path() {
            fd --hidden --exclude .git . "$1"
          }

          # Use fd to generate the list for directory completion
          _fzf_compgen_dir() {
            fd --type=d --hidden --exclude .git . "$1"
          }

          source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
          source "''${HOME}/.dotfiles/zsh/p10k.zsh"
          source "''${HOME}/.dotfiles/zsh/p10k-extensions.zsh"
          source "''${HOME}/.dotfiles/zsh/keybindings.zsh"
          source "''${HOME}/.dotfiles/zsh/env.zsh"
          source "''${HOME}/.dotfiles/zsh/alias.zsh"
          source "''${HOME}/.dotfiles/zsh/zsh-hooks.zsh"

          #endregion initExtraFirst
        '';

        initExtra = ''
          #region initExtra
          fastfetch
          #endregion initExtra
        '';

        shellAliases = {
          nixrebuild = "sudo nixos-rebuild --specialisation 01-niri switch --flake path:${config.configOptions.flake.dir}#${config.configOptions.flake.hash}";
          nixrebuild-boot = "sudo nixos-rebuild boot --flake path:${config.configOptions.flake.dir}#${config.configOptions.flake.hash}";
          nixflake-update = "sudo nix flake update path:${config.configOptions.flake.dir}";
          gcCleanup = "nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
        };

      };
    };
  };
}
