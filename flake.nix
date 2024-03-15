{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    ondsel-nix.url = "github:pinpox/ondsel-nix";
  };

  outputs = { nixpkgs, home-manager, ondsel-nix, ... }:
    let
      system = "x86_64-linux";

      homeMangagerModules = [
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.dan = {
            imports = [ ./home.nix ];
          };
        }
      ];

      mkSystem = { hostname, ... }:
        nixpkgs.lib.nixosSystem {
          system = system;
          modules = [
            {
              nixpkgs.overlays = [
                (_: _: {
                  ondsel = ondsel-nix.packages.${system}.ondsel;
                })
              ];
            }

            ./common.nix
            ./${hostname}/configuration.nix
            ./${hostname}/hardware-configuration.nix
          ] ++ homeMangagerModules;
        };
    in
    {
      nixosConfigurations = {
        akari = mkSystem {
          hostname = "akari";
        };

        chinatsu = mkSystem {
          hostname = "chinatsu";
        };
      };
    };
}
