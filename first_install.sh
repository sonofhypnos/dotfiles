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

sudo apt install zsh git curl nix-bin

SHARE="$HOME/.local/share/"
TRI="$HOME/.local/share/tridactyl"

if [ -d "$SHARE" ] && [ ! -d "$TRI" ]; then
  if confirm 'Do you want to install tridactyl?(y/n)\n'; then
    curl -fsSl https://raw.githubusercontent.com/tridactyl/native_messenger/master/installers/install.sh -o /tmp/trinativeinstall.sh && sh /tmp/trinativeinstall.sh 1.22.1
  fi
fi

home_manager_dir="$HOME/.dotfiles/config/home-manager"

if confirm "Do you want to recompile the home-manager configuration?"; then
    [[ -e $home_manager_dir ]] && cd "$home_manager_dir" && {
      echo "Running: home-manager switch"
      nix-shell -p home-manager 'home-manager --extra-experimental-features "nix-command flakes" switch -b backup --flake .#tassilo --show-trace 2>&1'
    }

    if [ -x "$HOME/.config/emacs/bin/doom" ]; then
      echo "Running: doom install"
      "$HOME/.config/emacs/bin/doom" install 2>&1
    else
      echo "Doom not found at $HOME/.config/emacs/bin/doom"
    fi
fi
