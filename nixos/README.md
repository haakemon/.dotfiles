sudo nixos-rebuild --upgrade switch --flake .
sudo nixos-rebuild --upgrade --option eval-cache false switch --flake .

nix flake lock --update-input nixpkgs .
nix flake update .


# Waydroid

After uninstall, manual cleanup:

sudo rm -rf /var/lib/waydroid /home/.waydroid ~/waydroid ~/.share/waydroid ~/.local/share/applications/*aydroid* ~/.local/share/waydroid
