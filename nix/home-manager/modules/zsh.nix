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
    ".config/zsh/.zshrc".source =
      config.lib.file.mkOutOfStoreSymlink "${config.user-config.home}/.dotfiles/zsh/.zshrc";
    ".zshenv".source =
      config.lib.file.mkOutOfStoreSymlink "${config.user-config.home}/.dotfiles/zsh/.zshenv";
  };
}
