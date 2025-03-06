{
  description = "My home-manager config as a flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

    nixpkgs-unfree = { url = "github:NixOS/nixpkgs/nixos-24.05"; };
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-igc-src = {
      url = "github:emacs-mirror/emacs/feature/igc";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unfree, nixpkgs-unstable, home-manager, nur
    , emacs-igc-src, ... }:
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
              firefox = nixpkgs-unstable.legacyPackages.${prev.system}.firefox;

              # Define emacs-igc inside flake.nix
              emacs-igc = prev.emacs-git.overrideAttrs (oldAttrs: {
                src = emacs-igc-src;
                buildInputs = oldAttrs.buildInputs ++ [ prev.mps ];
                configureFlags = oldAttrs.configureFlags
                  ++ [ "--with-mps=yes" ];
                postInstall = (oldAttrs.postInstall or "") + ''
                  mv $out/bin/emacs $out/bin/emacs-igc
                  mv $out/bin/emacsclient $out/bin/emacsclient-igc
                '';
              });
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
          ./privileged.nix
          {
            home = {
              username = "tassilo";
              homeDirectory = "/home/tassilo";
              stateVersion = "24.05";
            };
          }
        ];
      };
    in { homeConfigurations = { tassilo = home; }; };
}
