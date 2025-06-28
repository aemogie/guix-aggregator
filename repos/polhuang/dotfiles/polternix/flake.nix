# to reconfigure: home-manager --flake .#nineveh switch

{
  description = "Nix Home Manager config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };



  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      username = "pol";
      homeDirectory = "/home/pol";
    in {
      homeConfigurations.nineveh = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };


        modules = [
          ./home/default.nix
        ];
      };
    };
}
