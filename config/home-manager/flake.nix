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
  };

  outputs =
    { self, nixpkgs, nixpkgs-unfree, nixpkgs-unstable, home-manager, nur, ... }:
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
              ollamaUnstable = unstable.ollama;
              codexUnstable = unstable.codex;
              signalUnstable = unstable.signal-desktop;
            })
          ];

        };
        modules = [ ./home.nix ./privileged.nix ];
      };
    in { homeConfigurations = { tassilo = home; }; };
}
