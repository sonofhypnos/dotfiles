{
  description = "My home-manager config as a flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";

    nixpkgs-unfree = { url = "github:NixOS/nixpkgs/nixos-23.05"; };
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, nixpkgs-unfree, nixpkgs-unstable, home-manager, nur, ... }:
    let
      home = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs-unfree {
          system = "x86_64-linux";
          config = {
            allowUnfree = true;
            # Additional configurations and overlays if needed
          };
          overlays = [
            nur.overlays.default
            (final: prev: {
              # Access unstable packages like this
              firefox = nixpkgs-unstable.legacyPackages.${prev.system}.firefox;
            })
          ];

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
