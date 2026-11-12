{
  description = "My NixOS Flake Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/ac588ef1c914"; # Your pinned commit
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations = {
      reproducible-box = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux"; # Adjust if you are on a different architecture (e.g. aarch64-linux)
        modules = [
          ./configuration.nix
        ];
      };
    };
  };
}
