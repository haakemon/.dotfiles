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
        pkgs.rbw
        pkgs.pinentry-tty # dependency for rbw
      ];

      programs = {
        zsh = {
          initContent = ''
            #region initContent rbw.nix

            # 10080 minutes = 7 days
            eval $(keychain --timeout 10080 --eval --quiet)

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

            #endregion initContent rbw.nix
          '';
        };
      };
    };
}
