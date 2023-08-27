{ config, lib, pkgs, ... }:

let
  pkgsUnstable = import <nixpkgs-unstable> {
    config.allowUnfree = true;

  }; # This line allows me to selectively use unstable version (it also enables unfree packages in this version)
  clipboardScriptPath = ./urxvt_clipboard.pl;

  xresourcesContent = builtins.readFile
    /home/tassilo/.dotfiles/Xresources; # Read the content of the external file
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
  home.stateVersion = "23.05";

  # nixpkgs.overlays = [
  #  (import (builtins.fetchTarball {
  #    url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
  # }))
  #  ];

  home.packages = [
    pkgs.ripgrep
    pkgs.zathura
    pkgs.rxvt-unicode
    pkgs.fontconfig
    pkgs.xclip
    pkgs.git-lfs
    pkgs.git
    # pkgs.bfg-repo-cleaner
    pkgs.git-filter-repo
    # pkgsUnstable.lua54Packages.digestif
    # (pkgs.rxvt_unicode.override {
    #   withPerls = [ pkgs.rxvt_unicode_perl ]; # Add copy and paste to urxvt
    # })
    #pkgsUnstable._1password #NOTE: not installing 1password for now since connection between apps did not work
    #pkgsUnstable._1password-gui
  ];

  # Configuration for URxvt to use the Perl extension
  # xsession.terminal = {
  #   urxvt = {
  #     perl-lib = "${
  #         ./.
  #       }/urxvt_clipboard.pl"; # This line references the script in the current directory
  #   };
  # };
  home.file.".Xresources".text = ''
    ${xresourcesContent}  # Include content from Xresources

    URxvt.perl-lib: ${clipboardScriptPath}
    URxvt.perl-ext-common: default,clipboard
    URxvt.keysym.C-S-V: perl:clipboard:paste
  '';
  #In the above not sure what the line:
  #URxvt.perl-ext-common: default,clipboard
  #does exactly

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.git.lfs.enable = true;

}
