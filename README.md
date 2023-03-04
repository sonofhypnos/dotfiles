# dotfiles
Welcome to my [dotfiles](https://wiki.archlinux.org/title/Dotfiles) 👋! I use [dotbot](https://github.com/anishathalye/dotbot) to manage the files. 

## Overview
The following files/folders might be of interest to you:

 - `config/espanso/default.yml` textexpansions for [espanso](https://espanso.org)
 - `config/regolith` configuration for [regolith](https://regolith-linux.org/) = Ubuntu + i3
 - `nvim` neovim configuration and plugins
 - `gitconfig` git configuration

My [Doom-Emacs](https://github.com/hlissner/doom-emacs/blob/develop/docs/getting_started.org) files are in a separate [repo](https://github.com/sonofhypnos/emacs-config/)

## Install (intended for myself)

``` sh
git clone --depth 1 --recurse-submodules -j8 git@github.com:sonofhypnos/dotfiles.git
```

Once installed you need to run the `enable_services.sh` script with root to enable systemd services.

## miscellaneous/obscure
 - `Xcompose` Compose key file for the German [neo keyboard layout](https://neo-layout.org/).
 - `trydactylrc` [tridactyl](https://github.com/tridactyl/tridactyl) configuration - Vim navigation in Firefox

