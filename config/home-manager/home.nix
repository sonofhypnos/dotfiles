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
  myPythonEnv = pkgs.python3.withPackages (ps: [
    ps.python-lsp-server
    ps.pylsp-rope # Add this if available directly or adjust with an overlay if needed
  ]);
  # pkgs = nixpkgs.legacyPackages.${system};
in {
  # The below is here to make sure that .desktop files from ~/.nix-profiles/share/applications are accessed everywhere
  targets.genericLinux.enable = true; # This handles XDG_DATA_DIRS
  xdg.enable = true;
  xdg.systemDirs.data = [ "${config.home.homeDirectory}/.nix-profile/share" ];

  xdg.desktopEntries = {
    pdfdotsh = {
      name = "pdf.sh";
      exec = "pdf.sh %f";
      terminal = true; # asks if the application is run in a terminal window
      type = "Application";
      categories = [ "Office" ];
      mimeType = [ "application/pdf" ];
    };
  };

  # TODO: setting these manually like below seems like a viable option after we
  # have further figured out how mimeApps are currently set and once we imported all important settings from there
  # xdg.mimeApps = {
  #   enable = true;
  #   defaultApplications = {
  #     "application/pdf" = [ "org.gnome.Evince.desktop" ];
  #   };
  # };

  home = {
    packages = with pkgs; [

      firefox
      # myPythonEnv
      spotify
      elan
      git-secret
      stripe-cli # cli for stripe the payment system
      jq # cli tool for handeling json
      meme-suite
      ripgrep
      zathura
      rxvt-unicode # Terminal
      fontconfig
      xclip
      git-lfs # required to run git lfs
      git
      git-filter-repo # useful if you want to remove things from the git history permanently
      emacs29
      #texlab # for emacs lsp in tex

      # For screenshot automation:
      fswebcam
      jpegoptim

      jdk17_headless
      languagetool
      janet
      rnix-lsp
      zsh-nix-shell
      androidenv.androidPkgs_9_0.platform-tools
      zsh
      tmux
      elasticsearch
      okular
    ];

    # Or you can explicitly link the binary to a known location
    # activationScripts.link-pylsp = lib.stringAfter [ "writeBoundary" ] ''
    #   ln -sfn ${myPythonEnv}/bin/pylsp $HOME/.local/bin/pylsp
    # '';

    sessionVariables = { SHELL = "${pkgs.zsh}/bin/zsh"; };

    file."${envFile}".text = ''
      (setq languagetool-java-arguments '("-Dfile.encoding=UTF-8" "-cp" "${pkgs.languagetool}/share/")
          languagetool-java-bin "${pkgs.jdk17_headless}/bin/java"
          languagetool-console-command "${pkgs.languagetool}/share/languagetool-commandline.jar"
          languagetool-server-command "${pkgs.languagetool}/share/languagetool-server.jar")
    '';
    #      (after! nix-mode
    #        (add-to-list 'lsp-language-id-configuration '(nix-mode . "nix"))
    #        (lsp-register-client
    #         (make-lsp-client :new-connection (lsp-stdio-connection "nix-lsp")
    #                          :major-modes '(nix-mode)
    #                          :server-id 'nix-lsp))
    #        (add-hook 'nix-mode-hook #'lsp!))

    file.".Xresources".text = ''
      ${xresourcesContent}

      URxvt.perl-lib: ${clipboardScriptPath}
      URxvt.perl-ext-common: default,clipboard
      URxvt.keysym.C-S-V: perl:clipboard:paste
    '';

  };

  programs = {

    home-manager.enable = true;
    git.lfs.enable = true;

    firefox = {
      enable = true;
      profiles = {
        default = {
          # This makes it use the standard ~/.mozilla/firefox location
          path = ".mozilla/firefox";
        };
      };
    };

    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;
      enableCompletion = true;
      initExtra = ''
        ${builtins.readFile ../../zshrc}
      '';
      oh-my-zsh = {
        enable = true;
        theme = "fwalch";
        plugins = [
          "git"
          "alias-finder"
          "colored-man-pages"
          "colorize"
          "fasd"
        ]; # Add your plugins here
      };
      plugins = [{
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.7.0";
          sha256 = "149zh2rm59blr2q458a5irkfh82y3dwdich60s9670kl3cl5h2m1";
        };
      }];
    };
  };

}
