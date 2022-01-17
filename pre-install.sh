#!/usr/bin/env bash

# Check if doom is installed
DOOM="$HOME/.emacs.d"
if [ ! -d "$DOOM" ]; then
  echo 'Installing doom'
apt-get install ripgrep fd-find
git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d
~/.emacs.d/bin/doom install
else
  echo 'Updating doom'
  doom sync
fi

# Change default shell
if [[ ! $0 = "-zsh" ]]; then
  echo 'Changing default shell to zsh'
  chsh -s /bin/zsh
else
  echo 'Already using zsh'
fi
