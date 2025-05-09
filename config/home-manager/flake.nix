{
  description = "My home-manager config as a flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

    nixpkgs-unfree = { url = "github:NixOS/nixpkgs/nixos-24.11"; };
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
      system = "x86_64-linux";
      unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
      home = home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = { inherit unstable; };
        pkgs = import nixpkgs-unfree {
          inherit system;
          config = { allowUnfree = true; };
          overlays = [
            nur.overlays.default
            (final: prev: {
              # firefox = nixpkgs-unstable.legacyPackages.${prev.system}.firefox;
              ollama = nixpkgs-unstable.legacyPackages.${prev.system}.ollama;
              # Define emacs-igc inside flake.nix
              emacs-igc = prev.emacs30.overrideAttrs (oldAttrs: {
                pname = "emacs-igc";
                version = "30.1-igc";
                src = emacs-igc-src;
                buildInputs = oldAttrs.buildInputs
                  ++ [ prev.mps ]; # Ensure libmps is available
                configureFlags = oldAttrs.configureFlags
                  ++ [ "--with-mps=yes" ]; # Use MPS by default

                postFixup = (oldAttrs.postFixup or "") + ''
                  mv $out/bin/emacs $out/bin/emacs-igc
                  mv $out/bin/emacsclient $out/bin/emacsclient-igc
                  rm -f $out/lib/systemd/user/emacs.service
                  rm -rf $out/share/info/dired-x.info.gz
                ''; # We rename in this phase, since patchelf is run in this phase which still needs the regular binary name

              });
            })
          ];

        };
        modules = [
          ./home.nix
          ./privileged.nix
          {
            home = {
              username = "tassilo";
              homeDirectory = "/home/tassilo";
              stateVersion = "24.11";
            };
          }
        ];
      };
    in { homeConfigurations = { tassilo = home; }; };
}
