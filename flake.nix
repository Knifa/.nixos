{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/34bab064075b1eab277f8323f25fc99c4043c7a3";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, ... }: {
    nixosConfigurations.akari = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ 
        ./common.nix
        ./akari/configuration.nix 
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.dan = {
            imports = [ ./akari/home.nix ];
          };
        }
      ];
    };
  };
}
