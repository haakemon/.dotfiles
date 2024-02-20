{ config, pkgs, ... }:
let
  inherit (import ../options.nix)
    userHome
    flakeDir
    username
    flakeHash;
in
{
  home.packages = with pkgs; [
    killall
    wget
    fastfetch
    eza
    zsh-powerlevel10k
    (nerdfonts.override { fonts = [ "VictorMono" ]; })
    victor-mono
    bat
    fzf # fuzzy find
    grc # generic text colorizer
    jq
  ];

  home.file = {
    ".config/fastfetch/config.jsonc".source = config.lib.file.mkOutOfStoreSymlink "${userHome}/.dotfiles/fastfetch/config.jsonc";
  };

  programs = {
    home-manager.enable = true;
    zsh = {
      enable = true;
      enableCompletion = true;
      enableAutosuggestions = true;
      syntaxHighlighting.enable = true;

      history = {
        ignoreAllDups = true;
        path = ".local/share/zsh/zsh_history";
      };
      dirHashes = {
        code = "${userHome}/code";
        dl = "${userHome}/Downloads";
        dots = "${userHome}/.dotfiles";
        flake = "${flakeDir}";
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
      ];

      initExtraFirst = ''
        #region initExtraFirst
        autoload -Uz compinit
        compinit
        unsetopt beep

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
        nixrebuild = "sudo nixos-rebuild --upgrade switch --flake path:${flakeDir}#${flakeHash}";
        nixrebuild-boot = "sudo nixos-rebuild boot --flake path:${flakeDir}#${flakeHash}";
        nixflake-update = "sudo nix flake update path:${flakeDir}";
        gcCleanup = "nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
      };

    };
  };
}
