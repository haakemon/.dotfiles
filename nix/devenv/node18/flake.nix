{
  description = "A Nix-flake-based Node.js development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nodepkg.url = "github:nixos/nixpkgs/a71323f68d4377d12c04a5410e214495ec598d4c"; # nodejs_18.18.2 https://www.nixhub.io/packages/nodejs
  };

  outputs = { self, nixpkgs, nodepkg, ... }:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in
  {
    devShells."${system}".default = pkgs.mkShell
      {
        nativeBuildInputs = with pkgs; [
          nodepkg.legacyPackages.${system}.nodejs
          nodepkg.legacyPackages.${system}.corepack
        ];

        shellHook = ''
          clear
          export DEVENV=1

          tput setaf 5
          printf "Node: "
          ${nodepkg.legacyPackages.${system}.nodejs}/bin/node --version

          printf "pnpm: "
          ${nodepkg.legacyPackages.${system}.corepack}/bin/pnpm --version
          tput sgr0

          cd ~/code
          exec zsh
        '';
      };
  };
}
