{
  description = "A Nix-flake-based Node.js development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in
  {
    devShells."${system}".default = pkgs.mkShell
      {
        nativeBuildInputs = with pkgs; [
          nixpkgs.legacyPackages.${system}.dotnet-sdk_7
        ];

        shellHook = ''
          clear
          export DEVENV=1

          tput setaf 5
          printf "Dotnet: "
          ${nixpkgs.legacyPackages.${system}.dotnet-sdk_7}/bin/dotnet --version
          tput sgr0

          cd ~/code
          exec zsh
        '';
      };
  };
}
