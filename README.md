# dotfiles
Welcome to my [dotfiles](https://wiki.archlinux.org/title/Dotfiles) 👋! I use [dotbot](https://github.com/anishathalye/dotbot) to manage the files. 
I'd discourage just forking this repo, because lots of things here are specific to my workflow. Don't shoot yourself in the foot! Feel free to copy what you like though.

## Overview
The following files/folders might be of interest to you:

 - `config/espanso/default.yml` textexpansions for [espanso](https://espanso.org)
 - `config/home-manager/` my [home-manager](https://github.com/nix-community/home-manager) config (I am slowly trying to move more and more of my package-management and other config into home-manager)
 - `config/regolith` configuration for [regolith](https://regolith-linux.org/) ≅ Ubuntu + i3
 - `nvim` neovim configuration and plugins
 - `gitconfig` git configuration
 - whatever else I added since updating this readme


My [Doom-Emacs](https://github.com/hlissner/doom-emacs/blob/develop/docs/getting_started.org) files are in a separate [repo](https://github.com/sonofhypnos/emacs-config/)

## miscellaneous/obscure
 - `Xcompose` Compose key file for the German [neo keyboard layout](https://neo-layout.org/).
 - `trydactylrc` [tridactyl](https://github.com/tridactyl/tridactyl) configuration - Vim navigation in Firefox

## Setting up remote machine (intended for myself)

In case we want to push stuff to github:

``` bash
sudo apt update
sudo apt install git python3 curl neovim #zsh emacs
sudo apt install xz-utils #necessary for unpacking tarballs (which we need to install nix)
```

Install the repo
``` sh
git clone --depth 1 --recurse-submodules -j8 git@github.com:sonofhypnos/dotfiles.git ~/.dotfiles
```

Then run ./install.sh (make sure you have emacs and neovim installed)

put the following at the top of the bashrc (if your are using the local one)

``` bash
if [[ $TERM = "tramp" ]]; then
        unset RPROMPT
        unset RPS1
        PS1="$ "
        unsetopt zle
        unsetopt rcs  # Inhibit loading of further config files
        return
fi

```


If this is your desktop, once installed you need to run the `enable_services.sh` script with root to enable systemd services. Next you want to figure out how to get the home manager installed for the programs you installed through it (like ripgrep. Longterm you want to move as much as possible of your programs from apt to nix).


## Setting up desktop:

Allow sleep in user mode (necessary to enable a scheduled sleep from your i3 config):

Edit/create a sleep file:
``` sh
sudo echo "tassilo ALL=(ALL) NOPASSWD: /usr/bin/systemctl suspend" > /etc/sudoers.d/sleep
```

Setup services and timers:

At the moment, user-level systemd timers are automatically enabled. The borg backup timer needs to be set manually (and possibly others):

``` bash
sudo systemctl enable borg.service
sudo systemctl enable borg.timer
sudo systemctl start borg.timer
```


To check when your timers are running next, you can run:


``` bash
systemctl list-timers
```
or 

``` bash
systemctl --user list-timers
```
for your user level timers.

crontab:
Add this:

``` crontab
0,10,20,30,40,50 * * * * ~/bin/bin/sousveillance.sh
```




## todos
- [ ] Make sure that things are still working without needing to install home-manager? (Or do we want that?)
- [ ] Make sure install does not do weird things when we haven't installed emacs
- [ ] By now I know instead of copying and modifying things under /etc/share/regolith/conf.d/ I can just overwrite them in ~/config/regolith2/Xresources. That is what the set_from_xresource keybinds are for. Undoing that would be nice to do before or after we move to regolith 3.0
- [ ] same for neovim (for commiting with git for example)
- [ ] move all dotbot stuff that I only need for my home to nix already (this is absolutely optional though.)
- [ ] create a bootstrap script to install nix and setup home-manager (for now I gave up on this, because nix doesn't like to work with root as docker does.)
