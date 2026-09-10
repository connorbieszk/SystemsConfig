{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    preservation.url = "github:nix-community/preservation";
    comin = {
      url = "github:nlewo/comin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    inputs@{ self, nixpkgs, ... }:
    {
      nixosConfigurations.astrovoyager = nixpkgs.lib.nixosSystem {
        modules = [
          inputs.disko.nixosModules.disko
          inputs.preservation.nixosModules.default
          ./hosts/astro/voyager/configuration.nix
          ./hosts/astro/voyager/disko.nix
          ./hosts/astro/voyager/preservation.nix

          inputs.comin.nixosModules.comin
          ({
            services.comin = {
              enable = true;
              remotes = [
                {
                  name = "origin";
                  url = "https://github.com/connorbieszk/SystemsConfig.git";
                  branches.main.name = "main";
                }
              ];
            };
          })
        ];
      };
    };
}
