{ config
, ...
}:
let
  sharedDirs = [
    ".dotfiles"
    ".ssh"
    ".config/vivaldi"
    ".config/nrk8s"
    ".config/nrk-wifi"
    ".config/npm"
    ".config/kube"
    "Downloads"
    "Pictures"
    "tmp"
    "code"
    "work"
  ];
in
{
  fileSystems = builtins.listToAttrs (
    map
      (dir: {
        name = "${config.user-config.home}/${dir}";
        value = {
          device = "/mnt/shared/home/${config.user-config.name}/${dir}";
          options = [ "bind" ];
          depends = [ "/mnt/shared" ];
        };
      })
      sharedDirs
  );

  systemd.tmpfiles.rules = map
    (
      dir: "d /mnt/shared/home/${config.user-config.name}/${dir} 0755 ${config.user-config.name} users -"
    )
    sharedDirs;
}
