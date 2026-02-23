{ config
, pkgs
, lib
, ...
}:

{
  options.containers = {
    containerd = lib.mkOption {
      type = lib.types.bool;
      description = "Enable containerd";
      default = false;
    };
    podman = lib.mkOption {
      type = lib.types.bool;
      description = "Enable podman";
      default = false;
    };
    docker = lib.mkOption {
      type = lib.types.bool;
      description = "Enable docker";
      default = false;
    };
  };

  config = {
    home.packages = builtins.concatLists [
      (lib.optionals config.containers.containerd [
        pkgs.containerd
        pkgs.nerdctl
        pkgs.runc
        pkgs.cni-plugins
      ])
      (lib.optionals config.containers.podman [
        pkgs.podman
        pkgs.podman-compose
      ])
      (lib.optionals config.containers.docker [
        pkgs.docker
        pkgs.docker-compose
      ])
    ];
  };
}
