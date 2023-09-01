{
  description = "My home-manager config as a flake";

  inputs = {
    nixpkgs.url = "https://nixos.org/channels/nixos-23.05";
    home-manager.url =
      "https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz";
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      home = home-manager.lib.homeManagerConfiguration {
        username = "tassilo";
        homeDirectory = "/home/tassilo";
        stateVersion = "23.05";
        configuration = { config, lib, ... }:
          let
            pkgsUnstable = import nixpkgs {
              inherit system;
              config.allowUnfree = true;
            };
            clipboardScriptPath = ./urxvt_clipboard.pl;
            xresourcesContent =
              builtins.readFile /home/tassilo/.dotfiles/Xresources;
            doomDir = ".doom.d";
            envFile = "${doomDir}/emacs-hm-env.el";
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
            home.file."${envFile}".text = ''
              (setq languagetool-java-arguments '("-Dfile.encoding=UTF-8" "-cp" "${pkgs.languagetool}/share/")
                    languagetool-java-bin "${pkgs.jdk17_headless}/bin/java"
                    languagetool-console-command "${pkgs.languagetool}/share/languagetool-commandline.jar"
                    languagetool-server-command "${pkgs.languagetool}/share/languagetool-server.jar")
            '';

            # ... Your previous home-manager config here.
            # Remember to replace `pkgs` with `pkgsUnstable` if you need packages from unstable.
          };
      };
    in { homeConfigurations = { tassilo = home; }; };
}
