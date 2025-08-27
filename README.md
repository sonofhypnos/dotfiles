# dotfiles

Welcome to my [dotfiles](https://wiki.archlinux.org/title/Dotfiles) 👋! I use [dotbot](https://github.com/anishathalye/dotbot) to manage the files. 

I'd discourage just forking this repo, because lots of things here are specific to my workflow. Don't shoot yourself in the foot! Feel free to copy what you like though.

## Overview

- `config/espanso/default.yml` - text expansions for [espanso](https://espanso.org)
- `config/home-manager/` - my [home-manager](https://github.com/nix-community/home-manager) config (I am slowly trying to move more and more of my package-management and other config into home-manager)
- `/nix` - contains files that are managed by home-manager
- `config/regolith` - configuration for [regolith](https://regolith-linux.org/) ≅ Ubuntu + i3
- `nvim` - neovim configuration and plugins
- `gitconfig` - git configuration

My [Doom-Emacs](https://github.com/hlissner/doom-emacs/blob/develop/docs/getting_started.org) files are in a separate [repo](https://github.com/sonofhypnos/emacs-config/).

## Miscellaneous/Obscure

- `Xcompose` - Compose key file for the German [neo keyboard layout](https://neo-layout.org/)
- `trydactylrc` - [tridactyl](https://github.com/tridactyl/tridactyl) configuration for Vim navigation in Firefox

# Setting up Machines (intended for myself)

## Setting Up Remote Machine 

In case we want to push stuff to GitHub:

```bash
sudo apt update
sudo apt install git python3 curl neovim nix-bin #zsh emacs
```

Install the repo:

```sh
git clone --depth 1 --recurse-submodules -j8 git@github.com:sonofhypnos/dotfiles.git ~/.dotfiles
```

Then run `./install.sh` (make sure you have emacs and neovim installed).

`./install.sh` will also ask you if you want to recompile your home-manager config.

Put the following at the top of the bashrc (if you are using the local one):

```bash
if [[ $TERM = "tramp" ]]; then
        unset RPROMPT
        unset RPS1
        PS1="$ "
        unsetopt zle
        unsetopt rcs  # Inhibit loading of further config files
        return
fi
```

## Setting Up Desktop

```bash
sudo apt update
sudo apt install git python3 curl neovim nix-bin #zsh emacs
```

### Setup Neo Keyboard

Enable neo keyboard with GNOME:

```sh
gsettings set org.gnome.desktop.input-sources show-all-sources true
```

System-wide:

```sh
sudo localectl --no-convert set-x11-keymap de pc105 neo_qwertz
```

### Setup Regolith

- [ ] Check the latest way of installing regolith [here](https://regolith-desktop.com/docs/using-regolith/install/)

Remove config files we already have installed. To find the correct config file to remove, we run:

```bash
~ dpkg -S /usr/share/regolith/i3/config.d/60_config_keybindings 
regolith-i3-control-center-regolith: /usr/share/regolith/i3/config.d/60_config_keybindings
~ dpkg -L regolith-i3-control-center-regolith
/.
/usr
/usr/share
/usr/share/doc
/usr/share/doc/regolith-i3-control-center-regolith
/usr/share/doc/regolith-i3-control-center-regolith/changelog.Debian.gz
/usr/share/doc/regolith-i3-control-center-regolith/copyright
/usr/share/regolith
/usr/share/regolith/i3
/usr/share/regolith/i3/config.d
/usr/share/regolith/i3/config.d/60_config_keybindings
~ 
```

What we see above is what we should see if regolith-i3-control-center-regolith only modifies a single file.

Remove the keybindings config from regolith (since you configure it manually):

```bash
sudo apt remove regolith-i3-control-center-regolith
```

Add your favorite look:

```bash
sudo apt install regolith-look-*
```

The above doesn't literally work sadly:

```bash
sudo apt install regolith-look-blackhole 
```

### Install Applications via Snap That Otherwise Won't Work

```bash
sudo snap install steam anki-woodrow.anki
```

Download the latest Chrome version and run:

```bash
sudo apt install ./google-chrome-stable_current_amd64.deb
```

Same for 1password and run (you cannot install 1password via snap since it will be sandboxed and can't do everything you want):

```bash
sudo apt install ./1password-latest.deb 
```
- [ ] go to 1password and enable developer setings
- [ ] disable default keybinds in 1password, because they conflict with Ctrl+a on neoqwertz layout
- [ ] same for vscode
### Ubuntu 24.04 User Namespace Fix

Fixes Nix apps (dropbox, signal, chrome) getting `bwrap: Permission denied`:

```bash
echo 'kernel.apparmor_restrict_unprivileged_userns = 0' | sudo tee /etc/sysctl.d/20-apparmor-donotrestrict.conf
sudo sysctl --system
```

Test the fix:

```bash
unshare --user --map-root-user echo "success"
```

#### References

- [Ubuntu Community Hub discussion](https://discourse.ubuntu.com/t/spec-unprivileged-user-namespace-restrictions-via-apparmor-in-ubuntu-23-10/37626)
- [Ask Ubuntu solution](https://askubuntu.com/questions/1511854/how-to-permanently-disable-ubuntus-new-apparmor-user-namespace-creation-restric)

### Firefox

Set `.dotfiles/bin/pdf.sh` as the default application for PDFs.

Also enable org-protocol (refer to your notes for how to setup or debug org-protocol).

### Dropbox

Install Dropbox by downloading the latest .deb file and use `apt install ./dropbox-file.deb` to install it.

Run Dropbox once on the command line with:

```sh
dropbox start -i
```

It will ask you to connect Dropbox with this laptop by opening a URL for login.

### Zotero

- [ ] Fix my entire backup setup (In my new setup, I will only backup user-owned things.)
- [ ] First you need to manually install two addons below. Download their files (use wget, since Firefox will try to install them by default) and then go to "Tools > Plugins" in Zotero to install them.
  - The Better BibTeX addon. Zotero will otherwise think something is wrong if you try to export things in the Better BibTeX format.
    Download the latest version from the release from [the GitHub repository](https://github.com/retorquere/zotero-better-bibtex)
  - This addon for duplicates if you want to handle them: https://github.com/ChenglongMa/zoplicate/releases/tag/3.0.8
- [ ] Make sure that the versions of the addons are compatible with your Zotero version.
- [ ] Configure auto-export for your Zotero library entries. Go to "File > Export Library...". Check the box for "Keep updated". This option will not exist if you have not added the Better BibTeX addon! We are currently storing them under `~/repos/bibliography/My Library.bib`. You have to manually set the auto-export folder.

### Device-Specific Information and Considerations Regarding Backup

So far, we always backed up all our files including files under `/` like `/var/`. Turns out our backup is getting really complicated though, because doing it like this requires us to run our backup as root, which messes with us being able to get prompted through a GUI by our backup. I could write a nicer backup that takes care of this. What seems like a more pleasant solution is to decide that everything under root will have to be configured manually, and while the idea of having logs of what happened after my laptop crashes is pleasant, who in practice is going to investigate this for my desktop laptop anyway. I don't have the time for that either.

This also makes another thing more uncomplicated. I think it probably makes a lot of sense to separate out our home directory to be on a different disk than the root directory. Last time I put `~/repos` on a separate disk, because it was so large, but that was then inconvenient when we were jumping out of repos in Emacs.

### Set Dark Mode

Set GNOME's dark theme preference explicitly:

```bash
gsettings set org.gnome.desktop.interface gtk-theme 'Yaru-dark'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
```

### Enable Sync + OOM Killer Only (Secure)

We enable:

```
16 =  0x10 - enable sync command (s)
32 =  0x20 - enable remount read-only (u)
64 =  0x40 - enable signalling of processes (term, kill, oom-kill) (f)
128 =  0x80 - allow reboot/poweroff (b)
```

Check if `/etc/sysctl.d/99-sysrq.conf` exists.

Check the current value of the commands via:

```bash
cat /proc/sys/kernel/sysrq
```

s, u, b is probably enabled, so the value is 176 on Ubuntu. If the value is something else, perhaps you have other keys enabled and you would want to change the command below.

```bash
echo 'kernel.sysrq = 240' | sudo tee /etc/sysctl.d/99-sysrq.conf
sudo sysctl -p
```

Test if killing memory is working via:

```bash
python3 -c "x=[0]*10**8; input('Press Enter to exit or Ctrl+C to kill: ')"
```

### Setup shell

### Setup Backup

- [ ] Forget the things below on setting up your backup for root! We are going to only backup things owned by the user in the future. Fewer problems with permissions. We just manually edit the configuration for root and document it well.
- [ ] You will have to remove the `~/.config/systemd` directory created by home-manager once, so that we can first write the files from dotbot there, before we proceed to add the ones from home-manager.

### Checking Timers

To check when your timers are running next, you can run:

```bash
systemctl --user list-timers
```

for your user-level timers.

### Install Other Great Applications That You Can't Install via Nix

(Possibly because they need root access)

```bash
sudo apt install logwatch
```

## Anki

You might have to install anki addons again. Anki addons you usually like to use:
Image Occlusion Enhanced
Review Heatmap
Flexible Cloze 2
Batch Note editing
Search and replace tags

(use Flexible Cloze 2 min note type)

## Secrets

So far we don't have a proper solution to secrets.

### Magic SysRq Keys

On the ThinkPad T460, the magic key just requires you to press Fn. Just Fn+F is going to kill the application with the most memory etc.

[More documentation on the magic key bitmap](https://docs.kernel.org/admin-guide/sysrq.html).

## TODOs

- [ ] Add secrets for backup 
- [ ] Add secrets for SSH (check which ones you want on desktop or other machines etc.)
- [ ] Note: there is a problem, because we need the home-manager setup thing, but to get that zshrc and bashrc need to be set up if we want to add things under `~/bin` to the path, but this is done by home-manager:
  - [ ] Insight: we do not need to properly install home-manager: we can use `nix-shell -p home-manager` and then install home-manager with home-manager! (This worked for me on a new install flawlessly)
- [ ] Fix your version control setup with Dropbox? Using a remote to backup your stuff doesn't work, because your repository is too big. Probably the easiest solution is to just give up on having a remote and to just use ... instead.
- [ ] Find a fix for the fact that home-manager wants to sandbox my applications when I do not want that
- [ ] Try bash with starship, fzf and bash-completion and see if you can get rid of zsh as something you need to install extra.
- [ ] Remove or fix the script where we are automatically trying to install home-manager and nix. They don't work in their current form, because they already expect scripts we added to our `/bin` to be in the path.
- [ ] Create better action logging tools/lifelogging tools for LLMs to process:
  - [ ] Archive URLs with all of the text I read
  - [ ] Enable eye-tracking and use that to extract what text on a page I am reading
- [ ] Make sure that things are still working without needing to install home-manager? (Or do we want that?)
- [ ] Make sure install does not do weird things when we haven't installed Emacs
- [ ] By now I know instead of copying and modifying things under `/etc/share/regolith/conf.d/` I can just overwrite them in `~/config/regolith2/Xresources`. That is what the `set_from_xresource` keybinds are for. Undoing that would be nice to do before or after we move to regolith 3.0
- [ ] Same for neovim (for committing with git for example)
- [ ] Move all dotbot stuff that I only need for my home to nix already (optional)
- [ ] Create a bootstrap script to install nix and setup home-manager (for now I gave up on this, because nix doesn't like to work with root as docker does.)
- [ ] Create better paths for shell (use `$HOME` instead of `/home/tassilo`) 
- [ ] Move more configuration to home-manager and make it declarative.
