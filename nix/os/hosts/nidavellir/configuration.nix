{ inputs
, config
, modulesPath
, lib
, pkgs
, ...
}:
let
  secretspath = builtins.toString inputs.sops-secrets;
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix

    ./user-config.nix
    ./hardware-configuration.nix

    ../../modules/base.nix
    # ../../modules/users.nix
    # ../../modules/ssh.nix
    # ../../modules/zsh.nix
    ../../modules/nh.nix
    # ../../modules/git.nix
    ../../modules/ssh.nix
    ../../modules/sops.nix
  ];

  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
    pkgs.nano
  ];

  programs.zsh.enable = true;

  users.users.${config.user-config.name} = {
    isNormalUser = true;
    linger = true;
    description = config.user-config.name;
    home = config.user-config.home;
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
      "tty"
    ];
    shell = pkgs.zsh;
    packages = [ ];

    initialHashedPassword = "$y$j9T$OjxqKHTz.DzG0g35dBSxZ1$2Y64Qeu.BhBPvvi761g1admLGs0m4IsnpiBVInom9ZD";
  };

  networking = {
    hostName = "${config.system-config.hostname}";
    networkmanager.enable = true;
  };

  security.sudo.wheelNeedsPassword = false;

  sops = {
    secrets = {
      "ssh/authorized_keys" = {
        sopsFile = "${secretspath}/secrets/hosts/${config.system-config.hostname}/${config.system-config.hostname}.yaml";
        path = "${config.user-config.home}/.ssh/authorized_keys";
        owner = config.users.users.${config.user-config.name}.name;
        group = config.users.users.${config.user-config.name}.group;
        mode = "0640";
      };
      "ssh/id_ed25519" = {
        sopsFile = "${secretspath}/secrets/hosts/${config.system-config.hostname}/${config.system-config.hostname}.yaml";
        path = "${config.user-config.home}/.ssh/id_ed25519";
        owner = config.users.users.${config.user-config.name}.name;
        group = config.users.users.${config.user-config.name}.group;
        mode = "0600";
      };
      "ssh/id_ed25519.pub" = {
        sopsFile = "${secretspath}/secrets/hosts/${config.system-config.hostname}/${config.system-config.hostname}.yaml";
        path = "${config.user-config.home}/.ssh/id_ed25519.pub";
        owner = config.users.users.${config.user-config.name}.name;
        group = config.users.users.${config.user-config.name}.group;
        mode = "0644";
      };
    };
  };

  system.stateVersion = "24.05";

  home-manager.users.${config.user-config.name} =
    { config
    , pkgs
    , ...
    }:
    {

      imports = [
        ./user-config.nix
      ];

      home = {
        stateVersion = "24.05"; # Please read the comment before changing.

        packages = [
        ];
      };
    };
}
