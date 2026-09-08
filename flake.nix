{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    preservation.url = "github:nix-community/preservation";
    preservation.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = inputs@{ self, nixpkgs, disko, preservation, ... }: {
    # NOTE: 'nixos' is the default hostname
    nixosConfigurations.astrovoyager = nixpkgs.lib.nixosSystem {
      modules = [ 
        disko.nixosModule.disko
        preservation.nixosModule.default
        ./configuration.nix 
        ./disko.nix
        ./preservation.nix
        ];
    };
  };
}

