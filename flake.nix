{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    preservation.url = "github:nix-community/preservation";
  };
  outputs = inputs@{ self, nixpkgs, ... }: {
    # NOTE: 'nixos' is the default hostname
    nixosConfigurations.astrovoyager = nixpkgs.lib.nixosSystem {
      modules = [
        inputs.disko.nixosModules.disko
        inputs.preservation.nixosModules.default
        ./hosts/astro/voyager/configuration.nix 
        ./hosts/astro/voyager/disko.nix
        ./hosts/astro/voyager/preservation.nix
        ];
    };
  };
}

