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
(./install.sh will also ask you if you want to recompile your home-manager config)

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



## Setting up desktop:

- [ ] If this is your desktop, once installed you need to run the `enable_services.sh` script with root to enable systemd services. Next you want to figure out how to get the home manager installed for the programs you installed through it (like ripgrep. Longterm you want to move as much as possible of your programs from apt to nix).

Allow sleep in user mode (necessary to enable a scheduled sleep from your i3 config):

Edit/create a sleep file:
``` sh
sudo echo "tassilo ALL=(ALL) NOPASSWD: /usr/bin/systemctl suspend" > /etc/sudoers.d/sleep
```

To setup your root backup service, compile your home-manager config and then run:

``` bash
sudo /home/tassilo/.nix-profile/bin/deploy-privileged
```

- [ ] For your root backup service to work, you need to store the access details:

``` sh
op read 'op://Personal/Encryption borg base laptop passphrase/password' | sudo tee /root/.borg_passphrase > /dev/null
sudo chmod 600 /root/.borg_passphrase
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

Firefox:

Set .dotfiles/bin/pdf.sh as the default application for pdfs.
Also enable org-protocol (refer to your notes for how to setup or debug org-protocol).

Zotero:
Make sure you configure autoexport for your zotero library entries. We are currently storing them under ~/repos/bibliography/zotLib.bib. You have to manually set the auto-export folder.

Next you need to manually install the better bibtex addon. Zotero will otherwise something is wrong if you try to export things in the better bibtex format. 
Download the latest version from the release from the github repository and make sure that the version of bibtex is compatible with your zotero version. (You also need to pay attention to that with all the other addons)
You also need to install this addon for duplicates if you want to handle them: https://github.com/ChenglongMa/zoplicate/releases/tag/3.0.8 




To do this, right-click your library in the left pane and select "Export Library...". In the dialog that appears, select "Better BibTeX" as the export format and check the "Keep updated" checkbox. Then, select the folder where you want to save the exported file (e.g., ~/repos/bibliography) and click "OK".

## Device specific information and considerations regarding backup
So far, we always backed up all our files including files under `/` like `/var/`. Turns out our backup is getting really complicated though, because doing it like this requires us to run our backup as root, which messes with us being able to get prompted through a gui by our backup. I could write a nicer backup that takes care of this. What seems like a more pleasant solution is to decide that everything under root will have to be configured manually, and while the idea of having logs of what happened after my laptop crashes is pleasant, who in practice is going to investigate this for my desktop laptop anyway. I don't have the time for that either.
This also makes another thing more uncomplicated. I think it probably makes a lot of sense to separate out our home directory to be on a different disk than the root directory. Last time I put ~/repos on a separate disk, because it was so large, but that was then inconvenient, when we were jumping out of repos in emacs.

### Magic SysRq Keys:
- On the Thinkpad T460 the magic key just requires you to press Fn. Just Fn+F is going to kill the application with the most memory etc.

[More documentation on the magic key bitmap](https://docs.kernel.org/admin-guide/sysrq.html).

## todos
- [ ] try bash with starship, fzf and bash-completion and see if you can get rid of zsh as something you need to install extra.
- [ ] remove or fix the script where we are automatically trying to install home-manager and nix. They don't work in their current form, because they already expect scripts we added to our /bin to be in the path.
- [ ] create better action logging tools/lifelogging tools for llms to process:
  - [ ] archive urls with all of the text I read
  - [ ] enable eye-tracking and use that to extract what text on a page I am reading
- [ ] Make sure that things are still working without needing to install home-manager? (Or do we want that?)
- [ ] Make sure install does not do weird things when we haven't installed emacs
- [ ] By now I know instead of copying and modifying things under /etc/share/regolith/conf.d/ I can just overwrite them in ~/config/regolith2/Xresources. That is what the set_from_xresource keybinds are for. Undoing that would be nice to do before or after we move to regolith 3.0
- [ ] same for neovim (for commiting with git for example)
- [ ] move all dotbot stuff that I only need for my home to nix already (optional)
- [ ] create a bootstrap script to install nix and setup home-manager (for now I gave up on this, because nix doesn't like to work with root as docker does.)
- [ ] create better paths for shell (use $HOME instead of /home/tassilo) 
- [ ] Move more configuration to home-manager and make it declarative.
