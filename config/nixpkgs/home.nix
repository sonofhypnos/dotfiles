{ config, lib, pkgs, ... }:

{
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

  nixpkgs.config.allowUnfree = true; # needed for 1password
  home.packages = with pkgs; [ ripgrep _1password ];

  #programs.emacs = {
  #    enable = true;
  #    package = pkgs.emacsGit;
  #   extraPackages = (epkgs: [ epkgs.vterm ] );
  # };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

}
