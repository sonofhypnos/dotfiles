#!/usr/bin/env sh
# lazy_loaders.sh - Lazy loading functions for heavy tools
# These work in both bash and zsh

# Determine the current shell
current_shell=$(ps -p $$ -o comm=)

# Lazy load conda
export CONDA_HOME="$HOME/miniconda3"
conda_setup() {
    if [ "$current_shell" = "zsh" ] || [ "$current_shell" = "-zsh" ]; then
        __conda_setup="$("$CONDA_HOME/bin/conda" 'shell.zsh' 'hook' 2>/dev/null)"
    else
        __conda_setup="$("$CONDA_HOME/bin/conda" 'shell.bash' 'hook' 2>/dev/null)"
    fi

    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "$CONDA_HOME/etc/profile.d/conda.sh" ]; then
            . "$CONDA_HOME/etc/profile.d/conda.sh"
        else
            export PATH="$CONDA_HOME/bin:$PATH"
        fi
    fi
    unset __conda_setup
}


# Create alias for conda and any other commands that need it
conda() {
    conda_setup
    command conda "$@"
}

# Lazy load SDKMAN
export SDKMAN_DIR="$HOME/.sdkman"
sdk() {
    if [ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]; then
        source "$SDKMAN_DIR/bin/sdkman-init.sh"
        command sdk "$@"
    else
        echo "SDKMAN not found"
    fi
}

# Lazy load nvm
export NVM_DIR="$HOME/.nvm"
nvm() {
    if [ -s "$NVM_DIR/nvm.sh" ]; then
        source "$NVM_DIR/nvm.sh"
        command nvm "$@"
    else
        echo "NVM not found"
    fi
}

# Define commonly used node commands that should trigger nvm loading
node() {
    unset -f node npm npx yarn
    if [ -s "$NVM_DIR/nvm.sh" ]; then
        source "$NVM_DIR/nvm.sh"
        command node "$@"
    else
        echo "NVM not found"
    fi
}

# Create aliases for other node-related commands
npm() {
    node --version >/dev/null
    command npm "$@"
}

npx() {
    node --version >/dev/null
    command npx "$@"
}

yarn() {
    node --version >/dev/null
    command yarn "$@"
}

# Lazy load pyenv
pyenv() {
    export PYENV_ROOT="$HOME/.pyenv"
    path_prepend "$PYENV_ROOT/bin"
    eval "$(command pyenv init -)"
    command pyenv "$@"
}
