{ config, lib, pkgs, ... }:

let
  pkgsUnstable = import <nixpkgs-unstable> {
    config.allowUnfree = true;
  }; # This line allows me to selectively use unstable version (it also enables unfree packages in this version)

in {

  home.username = "tassilo";
  home.homeDirectory = "/home/tassilo";
  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # nixpkgs.overlays = [
  #  (import (builtins.fetchTarball {
  #    url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
  # }))
  #  ];

  home.packages = [
    pkgs.ripgrep

    #pkgsUnstable._1password #NOTE: not installing 1password for now since connection between apps did not work
    #pkgsUnstable._1password-gui
  ];

  #programs.emacs = {
  #    enable = true;
  #    package = pkgs.emacsGit;
  #   extraPackages = (epkgs: [ epkgs.vterm ] );
  # };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

}
