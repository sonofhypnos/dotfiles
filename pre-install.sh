#!/usr/bin/env bash

# Check if doom is installed
# DOOM="$HOME/.emacs.d"
# if [ ! -d "$DOOM" ]; then
#   echo 'installing doom prereqs'
# apt-get install ripgrep fd-find
# git clone --depth 1 https://github.com/hlissner/doom-emacs "$HOME/.emacs.d"
#   echo 'installing doom'
# ~/.emacs.d/bin/doom install
# else
#   echo 'Doom is installed'
# fi

#Below does not work
# Change default shell
#if [[ ! $0 = "-zsh" ]]; then
#  echo 'Changing default shell to zsh'
#  chsh -s /bin/zsh
#else
#  echo 'Already using zsh'
#fi
#!/bin/bash

# Exit on error
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

# 1. Install Nix
if
  ! command -v nix-env &
  >/dev/null
then
  if confirm "Do you want to install Nix?"; then
    echo "Installing Nix..."
    curl -L https://nixos.org/nix/install | sh
    # Enable Nix for this script
    source "$HOME/.nix-profile/etc/profile.d/nix.sh"
  fi
fi

# 2. Install home-manager
if ! [ -e "$HOME/.config/nixpkgs/home.nix" ]; then
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


