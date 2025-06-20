{
  description = "My home-manager config as a flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    nixpkgs-unfree = { url = "github:NixOS/nixpkgs/nixos-25.05"; };
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
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
      unfreePredicate = pkg:
        builtins.elem (nixpkgs.lib.getName pkg) [
          "slack"
          "spotify"
          "1password-gui"
          "1password"
          "1password-cli"
          "discord"
          "dropbox"
          "google-chrome"
          "steam"
          "steam-original"
          "steam-unwrapped"
          "steam-run"
          "meme-suite"
          "copilot.vim"
          "video-downloadhelper"
          "tampermonkey"
          "onepassword-password-manager"
        ];
      unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfreePredicate = unfreePredicate;

      }; # By calling import on the package set, we get the raw package set, so
      # when we call it later, we don't do
      # "unstable.legacyPackages.${prev.system}.google-chrome", to get
      # google-chrome, we just do "unstable.google-chrome"
      home = home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = { inherit unstable; };
        pkgs = import nixpkgs-unfree {
          inherit system;
          config.allowUnfreePredicate = unfreePredicate;
          overlays = [
            nur.overlays.default
            (final: prev: {
              # firefox = nixpkgs-unstable.legacyPackages.${prev.system}.firefox;
              ollama = unstable.ollama;
              codex = unstable.codex;
              google-chrome = unstable.google-chrome;
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
        modules = [ ./home.nix ./privileged.nix ];
      };
    in { homeConfigurations = { tassilo = home; }; };
}
