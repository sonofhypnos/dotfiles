#!/usr/bin/env bash
# paths.sh - PATH management for both shells

# Basic system paths
path_prepend "/usr/local/bin"
path_prepend "$HOME/bin"

# User paths
path_prepend "$HOME/.local/bin"
path_prepend "$HOME/.dotfiles/bin"

# Modular/Mojo
export MODULAR_HOME="$HOME/.modular"
# Bun
export BUN_INSTALL="$HOME/.bun"

# Tool-specific paths
path_prepend "$MODULAR_HOME/pkg/packages.modular.com_mojo/bin"
path_prepend "$BUN_INSTALL/bin"
path_prepend "/home/tassilo/.cargo/bin"
path_prepend "$HOME/Installations/sratoolkit.3.1.1-ubuntu64/bin"
path_prepend "/usr/local/texlive/2023/bin/x86_64-linux/"
path_prepend "$HOME/go/bin"
path_prepend "$HOME/.local/lib/python3.9/site-packages/memacs/"
path_prepend "$HOME/.local/bin/edirect"
path_prepend "$HOME/.emacs.d/bin"
