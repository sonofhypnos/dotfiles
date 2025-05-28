#!/usr/bin/env bash
#title          :first_install.sh
#description    :Install your dotfiles for the first time on a machine that we expect to use for quite some time, so we install doom and everything
#author         :Tassilo Neubauer
#date           :20250528
#version        :0.1    
#usage          :./first_install.sh
#notes          :       
#============================================================================        

set -e

confirm() {
  read -p "$1 [y/N] " response
  case "$response" in
    [yY][eE][sS] | [yY])
      true
      ;;
    *)
      false
      ;;
  esac
}

sudo apt install zsh git curl

# 1. Install Nix
if ! command -v nix &>/dev/null; then
  if confirm "Do you want to install Nix?"; then
    echo "Installing Nix..."
    curl -L https://nixos.org/nix/install | sh
    # Enable Nix for this script
    source "$HOME/.nix-profile/etc/profile.d/nix.sh"
  fi
fi

# 2. Install home-manager
if [[ ! -e "$HOME/.config/nixpkgs/home.nix" && ! -e "$HOME/.config/home-manager/home.nix" ]]; then
  if confirm "Do you want to install home-manager?"; then
    echo "Installing home-manager..."
    nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
    nix-channel --update
    nix-shell '<home-manager>' -A install
  fi
fi

SHARE="$HOME/.local/share/"
TRI="$HOME/.local/share/tridactyl"

if [ -d "$SHARE" ] && [ ! -d "$TRI" ]; then
  if confirm 'Do you want to install tridactyl?(y/n)\n'; then
    curl -fsSl https://raw.githubusercontent.com/tridactyl/native_messenger/master/installers/install.sh -o /tmp/trinativeinstall.sh && sh /tmp/trinativeinstall.sh 1.22.1
  fi
fi

if confirm "Do you want to recompile the home-manager configuration?"; then
    [[ -e $home_dir ]] && cd "$home_dir" && {
      echo "Running: home-manager switch"
      home-manager switch -b backup --flake .#tassilo --show-trace 2>&1
    }

    if [ -x "$HOME/.config/emacs/bin/doom" ]; then
      echo "Running: doom install"
      "$HOME/.config/emacs/bin/doom" install 2>&1
    else
      echo "Doom not found at $HOME/.config/emacs/bin/doom"
    fi
fi
