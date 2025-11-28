{ config
, pkgs
, lib
, ...
}:

{

  home.packages = [
    pkgs.killall
    pkgs.wget
    pkgs.fastfetch
    pkgs.eza
    pkgs.zsh-powerlevel10k
    pkgs.entr # https://github.com/eradman/entr
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
  ];

  home.file = {
    ".config/fastfetch/config.jsonc".source =
      config.lib.file.mkOutOfStoreSymlink "${config.user-config.home}/.dotfiles/fastfetch/config.jsonc";
  };

  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      history = {
        ignoreAllDups = true;
        path = "${config.user-config.home}/.local/share/zsh/zsh_history";
      };
      dirHashes = {
        code = "${config.user-config.home}/code";
        dl = "${config.user-config.home}/Downloads";
        dots = "${config.user-config.home}/.dotfiles";
        flake = "${config.user-config.name}/.dotfiles/nix/os";
      };
      dotDir = "${config.user-config.home}/.config/zsh";

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

      initContent = lib.mkBefore ''
        #region initContent mkBefore zsh.nix
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

        fastfetch

        #endregion initContent mkBefore zsh.nix
      '';
    };
  };
}
