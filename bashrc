#!/bin/bash
# .bashrc - Bash shell configuration file

# Source common functions first (needed for path management)
if [ -f "$HOME/.shell/functions.sh" ]; then
  source "$HOME/.shell/functions.sh"
fi

# Source general settings
if [ -f "$HOME/.shell/general.sh" ]; then
  source "$HOME/.shell/general.sh"
fi

# Source bash-specific settings
if [ -f "$HOME/.shell/bash_specific.sh" ]; then
  source "$HOME/.shell/bash_specific.sh"
fi

# Source paths
if [ -f "$HOME/.shell/paths.sh" ]; then
  source "$HOME/.shell/paths.sh"
fi

# Source lazy loaders
if [ -f "$HOME/.shell/lazy_loaders.sh" ]; then
  source "$HOME/.shell/lazy_loaders.sh"
fi

# Source aliases
if [ -f "$HOME/.shell/aliases.sh" ]; then
  source "$HOME/.shell/aliases.sh"
fi

# Source bashrc_local_before if it exists
if [ -f "$HOME/.bashrc_local_before" ]; then
  source "$HOME/.bashrc_local_before"
fi

# Source bashrc_local if it exists (for quick testing without rebuilding home-manager)
if [ -f "$HOME/.bashrc_local" ]; then
  source "$HOME/.bashrc_local"
fi
