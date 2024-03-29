{
  description = "My home-manager config as a flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";

    nixpkgs-unfree = { url = "github:NixOS/nixpkgs/nixos-23.05"; };
    home-manager.url = "github:nix-community/home-manager/release-23.05";
  };

  outputs = { self, nixpkgs, nixpkgs-unfree, home-manager, ... }:
    let
      home = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs-unfree {
          system = "x86_64-linux";
          config = {
            allowUnfree = true;
            # Additional configurations and overlays if needed
          };
        };
        # pkgs = import nixpkgs {
        #   config = {
        #     allowUnfree = true;
        #     # other configurations...
        #   }; # in customizedPkgs.legacyPackages."x86_64-linux";
        # };
        modules = [
          ./home.nix
          {
            home = {
              username = "tassilo";
              homeDirectory = "/home/tassilo";
              stateVersion = "23.05";
            };
          }
        ];
      };
    in { homeConfigurations = { tassilo = home; }; };
}
