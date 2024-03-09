{
  description = "A very basic flake";

  outputs =
    { self
    , nixpkgs
    , chaotic
    , home-manager
    } @ inputs:
    let
      odin = import ./hosts/odin/variables-local.nix {
        lib = nixpkgs.lib;
      };
    in
    {
      nixosConfigurations = {
        odin = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/odin/configuration.nix
            chaotic.nixosModules.default
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users."${odin.config.configOptions.username}" = {
                imports = [
                  ./hosts/odin/variables-local.nix
                  ./hosts/odin/home/default.nix
                ];
              };
            }
          ];
        };
      };
    };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
  };
}
