# [NixOS](https://nixos.org)

I prefer to keep some "secrets" locally, and not part of the git history. I am relying on using `path:` prefix for the flakes to allow this (see <https://github.com/NixOS/nix/issues/7107#issuecomment-1366095373>). From what I understand this means that the entire flake directory is copied to the nix store, so any "secrets" would be readable there. For me that is not a problem, I just dont want them present in my git history (encrypted or not).

## Installing

1. Disable Secure Boot in BIOS.

2. Boot to ISO and follow installer steps to change location and keyboard settings. When you get to the users configuration, you can exit the wizard and open a terminal window.

3. Execute `sudo -i` to start a terminal session as the root user.

4. You can now follow the [official instructions](https://nixos.org/manual/nixos/stable/#sec-installation), or if you want to use full disk encryption, see [this guide](https://gist.github.com/ladinu/bfebdd90a5afd45dec811296016b2a3f).

5. After `nixos-install` has finished, you should enter the installation and set a password for the user defined in `users.user.[YOUR_USER]` in `configuration.nix`.
   1. `nixos-enter --root /mnt`
   2. `passwd [YOUR_USER]` and create your password
   3. Now you can reboot and enjoy NixOS!

---

sudo nixos-rebuild --upgrade switch --flake .

sudo nixos-rebuild --upgrade --option eval-cache false switch --flake .

nix flake lock --update-input nixpkgs .

nix flake update .

Convert WSL image to img that can be mounted: `qemu-img convert -f vhdx -O raw ext4.vhdx ext4.img`

## Waydroid

After uninstall, manual cleanup:

```shell
sudo rm -rf /var/lib/waydroid /home/.waydroid ~/waydroid ~/.share/waydroid ~/.local/share/applications/*aydroid* ~/.local/share/waydroid
```
