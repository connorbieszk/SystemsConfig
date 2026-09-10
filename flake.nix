{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    preservation.url = "github:nix-community/preservation";
    comin = {
      url = "github:nlewo/comin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, ... }:
    let
      system = "x86_64-linux";

      defaultModules = [
        inputs.disko.nixosModules.disko
        inputs.preservation.nixosModules.default
        ./modules/services/comin.nix
        ./modules/services/boot.nix
        ./modules/services/gpg.nix
        ./modules/services/kmscon.nix
        ./modules/services/locale.nix
        ./moudles/users/pblez.nix
      ];

      types = {
        desktop = [
          ./modules/desktop/comin-notifier.nix
          ./modules/desktop/gnome.nix
          ./modules/desktop/pipewire.nix
        ];
        server = [];
        vm = [];
      };

      mkHost = type: hostname: extraModules: nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = defaultModules 
          ++ (types.${type} or [])
          ++ extraModules;
      };
    in
    {
      nixosConfigurations = {        
        astrovoyager = mkHost "desktop" "astrovoyager" [
          ./hosts/astro/voyager/configuration.nix
          ./hosts/astro/voyagerzx/disko.nix
          ./hosts/astro/voyager/preservation.nix
        ];
      };
    };
}
