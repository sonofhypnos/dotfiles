#!/bin/bash -
#title          :update-home-manager.sh
#description    :Updates home-manager if home-manager exists on the system
#author         :Tassilo Neubauer
#date           :20250309
#version        :0.1
#usage          :./update-home-manager.sh
#notes          :
#bash_version   :5.1.16(1)-release
#============================================================================
home_dir="$HOME/.config/home-manager"

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

if confirm "Do you want to update home-manager?"; then
    [[ -e $home_dir ]] && cd "$home_dir" && home-manager switch -b backup --flake .#tassilo --show-trace
fi
