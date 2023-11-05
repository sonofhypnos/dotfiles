{
  description = "My home-manager config as a flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    lean4.url = "github:leanprover/lean4";
    home-manager.url = "github:nix-community/home-manager/release-23.05";
  };

  outputs = { self, nixpkgs, home-manager, lean4, ... }:
    let
      home = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux".override {
          overlays = [ lean4.overlay ];

        };
        modules = [
          ./home.nix
          {
            home = {
              # system = "x86_64-linux";
              username = "tassilo";
              homeDirectory = "/home/tassilo";
              stateVersion = "23.05";
            };
          }
        ];
      };
    in { homeConfigurations = { tassilo = home; }; };
}
