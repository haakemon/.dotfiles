{
  description = "A very basic flake";

  outputs = { self, nixpkgs, chaotic, home-manager }:
    let
      system = "x86_64-linux";
      hostname = "nixos";
      timezone = "Europe/Oslo";
      defaultLocale = "en_US.UTF-8";
      extraLocale = "nb_NO.UTF-8";

      username = "haakemon";

      lib = nixpkgs.lib;
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations = {
        nixos = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit hostname username timezone defaultLocale extraLocale; };
          modules = [
            chaotic.nixosModules.default
            ./configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = { inherit hostname username; };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users."${username}" = {
                imports = [
                  ./home.nix
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
