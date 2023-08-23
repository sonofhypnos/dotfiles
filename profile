# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi
if [ -f /home/tassilo/.nix-profile/etc/profile.d/nix.sh ]; then .
  /home/tassilo/.nix-profile/etc/profile.d/nix.sh
fi # added by Nix installer

#cargo
if [ -s "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi

# for homemanager
if [ -s "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
  . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
fi


#ghcup
[ -s "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env" # ghcup-env

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#pyenv
if [ -d ~/.pyenv ]; then
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/tassilo/.pyenv/versions/3.6.15/lib

    export PYENV_ROOT="$HOME/.pyenv"
    command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
fi

# >>> conda initialize >>>
__conda_setup="$('/home/tassilo/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -s "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
        . "$HOME/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/tassilo/miniconda3/bin:$PATH"
    fi
fi

unset __conda_setup
# <<< conda initialize <<<

# SDKMAN
if [ -d ~/.sdkman ]; then
    export SDKMAN_DIR="/home/tassilo/.sdkman"
    [[ -s "/home/tassilo/.sdkman/bin/sdkman-init.sh" ]] && source "/home/tassilo/.sdkman/bin/sdkman-init.sh"
fi
