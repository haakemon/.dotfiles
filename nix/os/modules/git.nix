{ config, lib, ... }:
let
  sshKeysToLoad = lib.attrsets.foldlAttrs
    (acc: key: value: ''
      ${acc}
      { sleep .3; rbw get "SSH Keys" --field "${value}"; } | script -q /dev/null -c 'ssh-add -t 7d "''${HOME}/.ssh/${key}"'
    '') ""
    config.configOptions.sshKeys;
in
{
  home-manager.users.${config.user-config.name} =
    { config
    , pkgs
    , lib
    , ...
    }:
    {
      home.packages = [
        pkgs.pre-commit
        pkgs.gh # github cli
        pkgs.nixpkgs-fmt # formatting .nix files
        pkgs.nixfmt-rfc-style # formatting .nix files
        pkgs.gcc # requirement for pre-commit nixpkgs-fmt
        pkgs.rustup # requirement for pre-commit nixpkgs-fmt
        pkgs.keychain
        pkgs.rbw
        pkgs.pinentry-tty # dependency for rbw
      ];

      programs = {
        git = {
          enable = true;
          delta = {
            enable = true;
          };
          extraConfig = {
            user = {
              name = "Håkon Bogsrud";
              email = "2082481+haakemon@users.noreply.github.com";
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
            #region git initExtra

            # 10080 minutes = 7 days
            eval $(keychain --absolute --dir "$XDG_RUNTIME_DIR"/keychain --agents ssh --timeout 10080 --eval --quiet)

            function load-ssh-keys {
              rbw unlock
              echo "''${YELLOW_COLOR}loading ssh keys...''${RESET_COLOR}"
              ${sshKeysToLoad}
              rbw lock
            }

            isSSHKeysNotLoaded=$(keychain -l)
            if [[ "$isSSHKeysNotLoaded" == "The agent has no identities." ]]; then
              load-ssh-keys
            fi

            #endregion git initExtra
          '';
        };
      };
    };
}
