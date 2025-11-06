{
  description = "My NixOS config";

  outputs =
    { self
    , ...
    }@inputs:
    let
      mkOverlays = config: import ./nixpkgs-overlays.nix config inputs;

      homeManagerConf = {
        home-manager = {
          extraSpecialArgs = {
            inherit inputs;
          };
          backupFileExtension = "backup";
          useGlobalPkgs = true;
          useUserPackages = true;
        };
      };

    in
    {
      nixosConfigurations = {
        odin = inputs.nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          system = "x86_64-linux";
          modules = [
            ./hosts/odin/configuration.nix
            inputs.chaotic.nixosModules.default
            inputs.niri.nixosModules.niri
            # inputs.stylix.nixosModules.stylix
            inputs.dotfiles-private.nixosModules.hosts.odin
            inputs.home-manager.nixosModules.home-manager
            homeManagerConf
            (
              { config, ... }:
              {
                nixpkgs.overlays = [ (mkOverlays config) ];
              }
            )
          ];
        };

        delling = inputs.nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          system = "x86_64-linux";
          modules = [
            ./hosts/delling/configuration.nix
            inputs.chaotic.nixosModules.default
            inputs.niri.nixosModules.niri
            # inputs.stylix.nixosModules.stylix
            inputs.home-manager.nixosModules.home-manager
            inputs.dotfiles-private.nixosModules.hosts.delling
            homeManagerConf
            (
              { config, ... }:
              {
                nixpkgs.overlays = [ (mkOverlays config) ];
              }
            )
          ];
        };

        heimdall = inputs.nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          system = "x86_64-linux";
          modules = [
            ./hosts/heimdall/configuration.nix
            inputs.home-manager.nixosModules.home-manager
            inputs.dotfiles-private.nixosModules.hosts.heimdall
            homeManagerConf
            (
              { config, ... }:
              {
                nixpkgs.overlays = [ (mkOverlays config) ];
              }
            )
          ];
        };

        # nix run nixpkgs#nixos-anywhere -- --flake .#nidavellir --generate-hardware-config nixos-generate-config ./hardware-configuration.nix <user>@<host>
        # nixos-rebuild --target-host <user>@<host> --flake path:/home/haakemon/.dotfiles/nix/os#nidavellir --sudo switch
        nidavellir = inputs.nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          system = "x86_64-linux";
          modules = [
            ./hosts/nidavellir/configuration.nix
            inputs.disko.nixosModules.disko
            inputs.home-manager.nixosModules.home-manager
            inputs.dotfiles-private.nixosModules.hosts.nidavellir
            homeManagerConf
            (
              { config, ... }:
              {
                nixpkgs.overlays = [ (mkOverlays config) ];
              }
            )
          ];
        };
      };

      nixOnDroidConfigurations = {
        ve = inputs.nix-on-droid.lib.nixOnDroidConfiguration {
          pkgs = import inputs.nixpkgs-2405 {
            system = "aarch64-linux";
          };
          modules = [ ./hosts/ve/configuration.nix ];

          home-manager-path = inputs.home-manager-2405.outPath;
        };
      };
    };

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    nixpkgs-stable = {
      url = "github:NixOS/nixpkgs/nixos-25.05";
    };

    nixpkgs-unstable-small = {
      url = "github:NixOS/nixpkgs/nixos-unstable-small";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs-stable";
    };

    # stylix = {
    #   url = "github:danth/stylix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    quickshell = {
      url = "github:outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ags = {
      url = "github:aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.astal.follows = "astal";
    };

    astal = {
      url = "github:aylur/astal";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ghostty = {
      url = "github:ghostty-org/ghostty";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zeditor = {
      url = "github:zed-industries/zed";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dotfiles-private = {
      url = "git+ssh://git@github.com/haakemon/.dotfiles-private.git?ref=main&shallow=1&dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-secrets = {
      url = "git+ssh://git@github.com/haakemon/sops.git?ref=main&shallow=1";
      flake = false;
    };

    nrk-hylla = {
      url = "git+ssh://git@github.com/nrkno/linux-hylla.git?ref=feature/nix-f5vpn&shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-2405 = {
      url = "github:NixOS/nixpkgs/nixos-24.05";
    };

    home-manager-2405 = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs-2405";
    };

    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs-2405";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.quickshell.follows = "quickshell"; # Use same quickshell version
    };

  };
}
