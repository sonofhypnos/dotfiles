if [[ $TERM = "tramp" ]]; then
        unset RPROMPT
        unset RPS1
        PS1="$ "
        unsetopt zle
        unsetopt rcs  # Inhibit loading of further config files
        return
fi
# If you come from bash you might have to change your $PATH. See:
# fix commandline with pycharm: https://stackoverflow.com/questions/41960441/why-my-zsh-in-pycharm-doesnt-have-correct-path
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Making ctrl+R work in neovim-terminal:
# For more info see https://github.com/junegunn/fzf/issues/809
[ -n "$NVIM_LISTEN_ADDRESS" ] && export FZF_DEFAULT_OPTS='--no-height'

# TODO Fix neovim (for some reason scrolling does not work anymore and I am starting in normal mode instead of insert mode by default
#if [[ -z $VIM ]] && [[ -z $INSIDE_EMACS ]]; then
#	INSIDE_VIM=1
#	nvim -c "terminal"
#fi

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="fwalch"
# ZSH_THEME="robbyrussell"

DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line if pasting URLs and other text is messed up.
DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"
# the reason why my uni-scratchpad hack is not working consistently is related to the auto-title feature

# Uncomment the following line to enable command auto-correction.
#ENABLE_CORRECTION="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

AUTO_PUSHD="true" #enables directories being pushed on a stack. To go back directories run popd

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
ZSH_CUSTOM="$HOME/.dotfiles/zsh/custom"

export EDITOR=nvim export VISUAL=nvim

# Functions
source ~/.shell/functions.sh

# Allow local customizations in the ~/.zshrc_local_before file
if [ -s ~/.zshrc_local_before ]; then
    source ~/.zshrc_local_before; fi

# Allow local customizations in the ~/.shell_local_before file
if [ -s ~/.shell_local_before ]; then
    source ~/.shell_local_before; fi

#   Emacs vterm support
if [[ "$INSIDE_EMACS" = 'vterm' ]]; then
    alias clear='vterm_printf "51;Evterm-clear-scrollback";tput clear'; fi

# Paths
source ~/.shell/paths.sh

# Aliases
source ~/.shell/aliases.sh


# fzf
if [ -e /usr/share/doc/fzf ]; then
    source /usr/share/doc/fzf/examples/key-bindings.zsh
    source /usr/share/doc/fzf/examples/completion.zsh; fi


# disable special meaning for brackets by default
alias rake='noglob rake'

[ -s ~/.fzf.zsh ] && source ~/.fzf.zsh

alias sudo='sudo '

#for prioritylists in lsp-mode (for better performance)
export LSP_USE_PLISTS=true

source /home/tassilo/.config/op/plugins.sh

export MODULAR_HOME="/home/tassilo/.modular"
export PATH="/home/tassilo/.modular/pkg/packages.modular.com_mojo/bin:$PATH"

export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export ESPANSO_CONFIG="~/.config/espanso/match/default.yml"

