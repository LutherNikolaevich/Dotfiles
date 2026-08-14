{
  description = "czx flake config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    ...
  } @ inputs: let
    system = "x86_64-linux";
  in {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ({ config, pkgs, ... }: {
            nixpkgs.overlays = [
              (final: prev: {
                unstable = nixpkgs-unstable.legacyPackages.${system};
              })
            ];
          })
          ./configuration.nix
        ];
      };
    };
  };
}