{
  description = "A Nix-flake-based Node.js development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    oldPkgs.url = "github:nixos/nixpkgs/d42c1c8d447a388e1f2776d22c77f5642d703da6"; # nodejs_20.12.2 https://www.nixhub.io/packages/nodejs
  };

  outputs = { self, nixpkgs, oldPkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells."${system}".default = pkgs.mkShell
        {
          nativeBuildInputs = with pkgs; [
            oldPkgs.legacyPackages.${system}.nodejs
            oldPkgs.legacyPackages.${system}.corepack
          ];

          shellHook = ''
            clear
            export DEVENV=1
            cd "''${DEVENV_START_DIR:-$HOME}"
            DEVENV_START_DIR=""

            tput setaf 5
            printf "Node: "
            ${oldPkgs.legacyPackages.${system}.nodejs}/bin/node --version

            printf "pnpm: "
            ${oldPkgs.legacyPackages.${system}.corepack}/bin/pnpm --version
            tput sgr0

            exec zsh
          '';
        };
    };
}
