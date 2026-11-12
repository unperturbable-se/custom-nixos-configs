{
  description = "My NixOS Flake Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/ac588ef1c914"; # Your pinned commit

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05"; # Match your nixpkgs version
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations = {
      reproducible-box = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux"; # Adjust if you are on a different architecture
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.raed = import ./home.nix;
          }
        ];
      };
    };
  };
}
