{ config, lib, pkgs, ... }:
let
  # pkgsUnstable = import nixpkgs {
  #   inherit system;
  #   config.allowUnfree = true;
  # }; NOTE: don't need unstable for now, but just keeping it here for when I do.
  clipboardScriptPath = ./urxvt_clipboard.pl;
  xresourcesContent = builtins.readFile ../../Xresources;
  doomDir = ".doom.d";
  envFile = "${doomDir}/emacs-hm-env.el";
  # pkgs = nixpkgs.legacyPackages.${system};
in {

  # home.username = "tassilo";
  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  # home.stateVersion = "23.05";

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
    pkgs.jdk17_headless
    pkgs.languagetool
    pkgs.janet
    pkgs.nix-lsp
  ];

  # programs.zsh = {
  #   enable = true;
  #   enableCompletion = true;
  #   plugins = [{
  #     name = "zsh-nix-shell";
  #     file = "nix-shell.plugin.zsh";
  #     src = pkgs.fetchFromGitHub {
  #       owner = "chisui";
  #       repo = "zsh-nix-shell";
  #       rev = "v0.7.0";
  #       sha256 = "149zh2rm59blr2q458a5irkfh82y3dwdich60s9670kl3cl5h2m1";
  #     };
  #   }];
  # };

  home.file.".Xresources".text = ''
    ${xresourcesContent}

    URxvt.perl-lib: ${clipboardScriptPath}
    URxvt.perl-ext-common: default,clipboard
    URxvt.keysym.C-S-V: perl:clipboard:paste
  '';

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.git.lfs.enable = true;
  home.file."${envFile}".text = ''
        (setq languagetool-java-arguments '("-Dfile.encoding=UTF-8" "-cp" "${pkgs.languagetool}/share/")
              languagetool-java-bin "${pkgs.jdk17_headless}/bin/java"
              languagetool-console-command "${pkgs.languagetool}/share/languagetool-commandline.jar"
              languagetool-server-command "${pkgs.languagetool}/share/languagetool-server.jar")

    (after! nix-mode
      (add-to-list 'lsp-language-id-configuration '(nix-mode . "nix"))
      (lsp-register-client
       (make-lsp-client :new-connection (lsp-stdio-connection "nix-lsp")
                        :major-modes '(nix-mode)
                        :server-id 'nix-lsp))
      (add-hook 'nix-mode-hook #'lsp!))
  '';

  # ... Your previous home-manager config here.
  # Remember to replace `pkgs` with `pkgsUnstable` if you need packages from unstable.
}
