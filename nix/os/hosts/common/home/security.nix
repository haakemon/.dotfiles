{ config, pkgs, lib, ... }:
let
  sshKeysToLoad = lib.attrsets.foldlAttrs
    (acc: key: value: ''
      ${acc}
      { sleep .3; rbw get "SSH Keys" --field "${value}"; } | script -q /dev/null -c 'ssh-add -t 7d "''${HOME}/.ssh/${key}"'
    '') ""
    config.configOptions.sshKeys;
in
{
  home.packages = [
    # Password management
    pkgs.keychain
    pkgs.bitwarden
    pkgs.rbw # https://crates.io/crates/rbw unofficial bitwarden CLI
    pkgs.pinentry-tty # dependency for rbw
  ] ++ lib.optionals (!config.configOptions.headless) [
    pkgs.keepassxc
    pkgs.protonvpn-gui
  ];

  programs = {
    zsh = {
      initExtra = ''
        #region security initExtra

        # 10080 minutes = 7 days
        eval $(keychain --agents ssh --timeout 10080 --eval --quiet)

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

        #endregion security initExtra
      '';
    };
  };
}
