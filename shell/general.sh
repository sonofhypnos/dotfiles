#!/bin/bash
# general.sh - Common settings for both bash and zsh

# Set default editor
export EDITOR=nvim
export VISUAL=nvim

# History settings (work in both bash/zsh)
HISTSIZE=10000
HISTFILESIZE=20000
SAVEHIST=$HISTSIZE

# Don't put duplicate lines in history
export HISTCONTROL=ignoreboth

# Some common environment variables
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# For better performance in lsp-mode
export LSP_USE_PLISTS=true

# Enable color support
if [ -x /usr/bin/dircolors ]; then
    test -r "$HOME/.dircolors" && eval "$(dircolors -b "$HOME/.dircolors")" || eval "$(dircolors -b)"
fi

# For espanso
export ESPANSO_CONFIG="$HOME/.config/espanso/match/default.yml"

# Making ctrl+R work in neovim-terminal:
# For more info see https://github.com/junegunn/fzf/issues/809
[ -n "$NVIM_LISTEN_ADDRESS" ] && export FZF_DEFAULT_OPTS='--no-height'

# Source 1Password plugins if they exist
if [ -f "/home/tassilo/.config/op/plugins.sh" ]; then
    source "/home/tassilo/.config/op/plugins.sh"
fi

# Configure to use gpg for password handleing
export GPG_TTY=$(tty)

export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent

export SUDO_ASKPASS=/usr/bin/ssh-askpass

# Make sure poetry puts venv in project directory
POETRY_VIRTUALENVS_IN_PROJECT=true

# # Tell poetry to use the same python version that was used to install it to avoid weird errors
# POETRY_VIRTUALENVS_USE_POETRY_PYTHON=true
