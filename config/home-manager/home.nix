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

  home.packages = [
    pkgs.ripgrep
    pkgs.zathura
    pkgs.rxvt-unicode
    pkgs.fontconfig
    pkgs.xclip
    pkgs.git-lfs
    pkgs.git
    pkgs.git-filter-repo
    pkgs.emacs29
    pkgs.texlab # for emacs lsp in tex
  ];

  home.file.".Xresources".text = ''
    ${xresourcesContent}

    URxvt.perl-lib: ${clipboardScriptPath}
    URxvt.perl-ext-common: default,clipboard
    URxvt.keysym.C-S-V: perl:clipboard:paste
  '';

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.git.lfs.enable = true;

}
