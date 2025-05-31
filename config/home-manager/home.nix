{ config, lib, pkgs, unstable, ... }:
let
  clipboardScriptPath = ./urxvt_clipboard.pl;
  doomDir = ".doom.d";
  envFile = "${doomDir}/emacs-hm-env.el";
  firefoxAddons = pkgs.nur.repos.rycee.firefox-addons;
  onePassPath = "~/.1password/agent.sock";
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
    nemo = {
      name = "Nemo";
      comment = "File Manager";
      icon = "folder";
      exec = "${pkgs.nemo}/bin/nemo %U";
      categories = [ "System" "FileTools" "FileManager" ];
      mimeType = [ "inode/directory" ];
      terminal = false;
      type = "Application";
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
    username = "tassilo";
    homeDirectory = "/home/tassilo";
    stateVersion = "25.05";

    packages = with pkgs; [
      # Communication & Social
      element-desktop # Matrix client for encrypted messaging
      discord # Gaming/community chat platform
      signal-desktop # Private messaging with end-to-end encryption

      # Web Browsers
      google-chrome # Chromium-based browser for web compatibility
      #firefox # somehow updating the nixos version made firefox collide?

      # Media & Entertainment
      spotify # Music streaming
      steam # Gaming platform

      # File Management & System Tools
      nemo # GUI file manager
      copyq # Clipboard manager with history
      trash-cli # CLI for trash operations (safer than rm)
      xclip # X11 clipboard utilities
      fontconfig # Font configuration and management

      # Productivity & Office
      anki # Spaced repetition flashcard system
      zotero # Reference manager for academic papers
      xournalpp # PDF annotation and note-taking
      #okular # Alternative PDF viewer

      # Development Tools - Core
      git # Version control system
      git-lfs # Git Large File Storage extension
      git-filter-repo # Tool for rewriting git history safely
      git-secret # Encrypt secrets in git repos
      emacs30 # Text editor/IDE
      direnv # Per-directory environment variables
      nix-direnv # Nix integration for direnv

      # Development Tools - Languages & LSPs
      janet # Minimal functional lisp dialect
      pyright # Python language server for IDE features
      jdk17_headless # Java development kit (headless)
      elan # Lean theorem prover toolchain manager

      # Development Tools - Formatters & Linters
      nixfmt-classic # Nix code formatter for syntax highlighting
      nodePackages.prettier # Multi-language code formatter (required by Emacs apheleia)
      languagetool # Grammar and style checker

      # CLI Utilities & Data Processing
      jq # Command-line JSON processor
      ripgrep # Fast text search tool (better grep)
      stripe-cli # CLI for Stripe payment platform API

      # Terminal & Shell
      rxvt-unicode # Lightweight Unicode terminal emulator
      zsh # Z shell with advanced features
      zsh-nix-shell # Zsh integration for nix-shell
      tmux # Terminal multiplexer for session management

      # Window Manager Tools
      i3-cycle-focus # Window cycling for i3/regolith desktop

      # Screenshot & Media Tools
      fswebcam # Webcam capture tool for screenshots/automation
      jpegoptim # JPEG optimization utility

      # Research & Biology
      meme-suite # Motif-based sequence analysis tools for bioinformatics
      ollama # Local LLM runner

      # Sandboxed applications (initially problematic on Ubuntu 24.04)
      codex # AI coding assistant

      #androidenv.androidPkgs_9_0.platform-tools # Android development tools (deprecated in 24.11, unused)

      # Custom Package: Git-Dropbox Integration
      (python3Packages.buildPythonApplication {
        pname = "git-remote-dropbox";
        version = "2.0.4";
        src = pkgs.fetchFromGitHub {
          owner = "anishathalye";
          repo = "git-remote-dropbox";
          rev = "v2.0.4";
          sha256 = "sha256-miA8lYfk77pXn5aWIh17uul1l+7w2VCBDT3+YiVK5OY=";
        };
        format = "pyproject";
        nativeBuildInputs = with pkgs.python3Packages; [
          hatchling
          hatch-vcs
          poetry-core
          setuptools
        ];
        propagatedBuildInputs = with python3Packages; [
          dropbox
          setuptools
          requests
        ];
        doCheck = false; # Skip tests (require Dropbox credentials)
      })
    ];

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
      URxvt.perl-lib: ${clipboardScriptPath}
      URxvt.perl-ext-common: default,clipboard
      URxvt.keysym.C-S-V: perl:clipboard:paste
    '';

    file = {
      ".XCompose".source = ../../nix/XCompose;
      ".gitconfig".source = ../../nix/gitconfig;
      ".config" = {
        source = ../../nix/.config;
        recursive = true;
      };
      "Dropbox/.keep" = {
        text = "";
      }; # We add an empty file to add an empty directory

    };

  };

  privileged.enable = true;

  dconf.settings = {
    "org/gnome/desktop/interface" = { color-scheme = "prefer-dark"; };
    "org/gnome/desktop/nautilus/preferences" = {
      show-hidden-files = true;
      show-image-thumbnails = "always";
      default-sort-order = "mtime"; # Sort by modification time
      default-sort-in-reverse-order = false; # Newest first if true
    };
  };
  programs = {
    ssh = {
      enable = true;
      extraConfig = ''
        IdentityAgent ${onePassPath}
      '';
    };
    fzf.enable = true;
    neovim = {
      enable = true;

      # Configure plugins using Nix
      plugins = with pkgs.vimPlugins; [
        # VIM enhancements
        securemodelines
        editorconfig-vim
        vim-sneak
        vim-surround
        vim-over
        vim-tridactyl

        # Copilot (doesn't work here, because it is not the newest version (What crap!))
        copilot-vim

        # Stop swapfiles
        vim-autoswap

        # GUI enhancements
        lightline-vim
        vim-highlightedyank
        vim-matchup

        # Fuzzy finder
        vim-rooter
        fzf-vim

        # Linting/spellchecking
        ale

        # Vim editing in browser
        vim-ghost

        # Code formatting
        neoformat

        # File management
        nerdtree

        # Saving as root
        vim-suda

        # vim-multisheet:
        (pkgs.vimUtils.buildVimPlugin {
          pname = "vim-multisheets";
          version = "2022-04-28"; # Use current date or commit date
          src = pkgs.fetchFromGitHub {
            owner = "tsvibt";
            repo = "vim-multisheets";
            rev = "main"; # Or specific commit hash if you prefer
            sha256 =
              "sha256-RAnpUMpgMPqKHpfufk2ieQDCyM2yfERSh6DNK9NoYwc="; # Leave empty first, Nix will error and tell you the correct hash
          };
        })

      ];
    };

    # NOTE: DO NOT add: "home-manager.enable = true;", because then we will add
    # a new version of home-manager that will conflict with the conflicting one
    # we need to have already installed to compile this config.
    git.lfs.enable = true;

    firefox = {
      # nativeMessagingHosts = [ "tridactyl" ]; # enables native messenger?
      enable = true;
      package = unstable.firefox;
      profiles = {
        default = {
          # This makes it use the standard ~/.mozilla/firefox location
          path = ".mozilla/firefox";
          settings = {
            # Cleanup url bar
            "browser.urlbar.suggest.topsites" = false;
            "services.sync.prefs.sync.browser.urlbar.suggest.topsites" = true;

            # Remove Sponsored Content
            "browser.newtabpage.activity-stream.showSponsored" = false;
            "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
            "browser.newtabpage.activity-stream.default.sites" = "";
            "browser.newtabpage.pinned" = "[]"; # Clears all pinned sites

            # Hide the Search Bar
            "browser.newtabpage.activity-stream.improvesearch.handoffToAwesomebar" =
              false;
            "browser.newtabpage.activity-stream.showSearch" = false;

            # Remove All Suggested Content
            "browser.newtabpage.activity-stream.feeds.section.topstories" =
              false;
            "browser.newtabpage.activity-stream.feeds.snippets" = false;
            "browser.newtabpage.activity-stream.feeds.topsites" = false;
            "browser.newtabpage.activity-stream.feeds.section.highlights" =
              false;

            # Disable annoying extension behavior
            "browser.download.autohideButton" = false;
            "extensions.getAddons.showPane" = false;
            "extensions.htmlaboutaddons.recommendations.enabled" = false;

            # Performance and UI improvements
            "browser.tabs.loadInBackground" = true;
            "browser.aboutConfig.showWarning" = false;
            "browser.compactmode.show" = true;
            "browser.toolbars.bookmarks.visibility" = "never";
            "browser.ctrlTab.recentlyUsedOrder" = false;

            # Display tabs even in fullscreen mode:
            "browser.fullscreen.autohide" = false;
          };
          extensions.packages =
            with firefoxAddons; [ # https://discourse.nixos.org/t/firefox-extensions-with-home-manager/34108/4
              video-downloadhelper
              tampermonkey
              web-search-navigator
              duckduckgo-privacy-essentials
              unpaywall
              istilldontcareaboutcookies
              zotero-connector
              tridactyl
              ublock-origin
              onepassword-password-manager
              darkreader
            ];
        };
      };
    };

    bash = {
      enable = true;
      # enableCompletion=true;
      initExtra = ''
        #!/usr/bin/env bash
        # .bashrc - Bash shell configuration file

        # Source common functions first (needed for path management)
        if [ -f "$HOME/.shell/functions.sh" ]; then
          source "$HOME/.shell/functions.sh"
        fi

        # Source general settings
        if [ -f "$HOME/.shell/general.sh" ]; then
          source "$HOME/.shell/general.sh"
        fi

        # Source paths
        if [ -f "$HOME/.shell/paths.sh" ]; then
          source "$HOME/.shell/paths.sh"
        fi

        # Source lazy loaders
        if [ -f "$HOME/.shell/lazy_loaders.sh" ]; then
          source "$HOME/.shell/lazy_loaders.sh"
        fi

        # Source aliases
        if [ -f "$HOME/.shell/aliases.sh" ]; then
          source "$HOME/.shell/aliases.sh"
        fi

        # Source bashrc_local if it exists (for quick testing without rebuilding home-manager)
        if [ -f "$HOME/.bashrc_local" ]; then
          source "$HOME/.bashrc_local"
        fi
      '';
    };
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      enableCompletion = true;
      initExtra = ''
        SSH_AUTH_SOCK=${onePassPath}
        # Home manager managed configuration

        # Source shell files for consistent configuration
        if [ -f "$HOME/.shell/functions.sh" ]; then
          source "$HOME/.shell/functions.sh"
        fi

        if [ -f "$HOME/.shell/general.sh" ]; then
          source "$HOME/.shell/general.sh"
        fi

        if [ -f "$HOME/.shell/paths.sh" ]; then
          source "$HOME/.shell/paths.sh"
        fi

        if [ -f "$HOME/.shell/lazy_loaders.sh" ]; then
          source "$HOME/.shell/lazy_loaders.sh"
        fi

        if [ -f "$HOME/.shell/aliases.sh" ]; then
          source "$HOME/.shell/aliases.sh"
        fi

        # Source local configuration (for quick changes without rebuilding)
        if [ -f "$HOME/.zshrc.local" ]; then
          source "$HOME/.zshrc.local"
        fi

        # Oh-my-zsh settings
        DISABLE_UPDATE_PROMPT="true"
        DISABLE_MAGIC_FUNCTIONS="true"
        AUTO_PUSHD="true" # enables directories being pushed on a stack
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

  services = {
    # dropbox.enable = true; #FIXME: for unknown reasons, dropbox doesn't render properly if we install it via nix.
    # dropbox.path = "/home/tassilo/Dropbox";
    espanso.enable = true;
    espanso.configs = { };
    espanso.matches = { };
  };

}
