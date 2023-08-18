#!/usr/bin/env sh

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
SHARE="$HOME/.local/share/"
TRI="$HOME/.local/share/tridactyl"

if [ -d "$SHARE" ] && [ ! -d "$TRI" ]; then
  printf 'Do you want to install tridactyl?(y/n)\n'
  read -r answer

  if [ "$answer" != "${answer#[Yy]}" ]; then # this grammar (the #[] operator) means that the variable $answer where any Y or y in 1st position will be dropped if they exist.
    curl -fsSl https://raw.githubusercontent.com/tridactyl/native_messenger/master/installers/install.sh -o /tmp/trinativeinstall.sh && sh /tmp/trinativeinstall.sh 1.22.1
  fi
fi
