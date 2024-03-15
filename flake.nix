{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    ondsel.url = "github:pinpox/ondsel-nix";
  };

  outputs = { nixpkgs, home-manager, ondsel, ... }:
    let
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
          system = "x86_64-linux";
          modules = [
            {
              nixpkgs.overlays = [
                (_: _: {
                  ondsel = ondsel;
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
