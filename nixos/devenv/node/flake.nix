{
  description = "A Nix-flake-based Node.js development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nodepkg.url = "github:nixos/nixpkgs/dd5621df6dcb90122b50da5ec31c411a0de3e538"; # https://www.nixhub.io/packages/nodejs
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
