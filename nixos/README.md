sudo nixos-rebuild --upgrade switch --flake .
sudo nixos-rebuild --upgrade --option eval-cache false switch --flake .

nix flake lock --update-input nixpkgs .
nix flake update .
