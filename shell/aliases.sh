#convenience
alias d='cd'
alias p='popd'
alias ll='ls -alFh'
alias l='ls -CF'
alias diff='diff --color=always'
alias grep='grep --color=always'
alias rgrep='rgrep --color=always'
alias fdfind='fdfind --color=always'
alias e='emacsclient -c'
alias less='less -R'
alias gll='git log --graph --pretty=oneline --abbrev-commit'
alias bat='batcat'
alias v="nvim"
alias vim="nvim"
alias pip2='python2 -m pip'
alias printpagesd='lpr -o number-up=2 sides=two-sided-long-edge -P HaDiKo-EUFF'
alias mat='MATLAB_JAVA=tassilo/.sdkman/candidates/java/8.0.282.fx-zulu/jre;matlab & disown'

alias refresh='watch -n 1 cat'

# Aliases to protect against overwriting
alias cp='cp -i'
alias mv='mv -i'
alias rm='echo "use trash instead you moron!";rm'
alias ainstall='sudo apt-get update -y & sudo apt-get upgrade -y && sudo apt-get install'

#directories and files
#alias do='cd ~/.dotfiles' this line caused a tone of problems for me, because do is a keyword in bash of course
alias regi3='vim ~/.dotfiles/config/regolith3/i3/config.d/45_custom_config'
alias aalias='emacsclient ~/.dotfiles/shell/aliases.sh'
alias ozsh='cd ~/.dotfiles/zsh/oh-my-zsh'
alias econfig='vim ~/.doom.d/config.el'
alias .d='cd ~/.dotfiles/'
alias ashell="vim ~/.dotfiles/shell/aliases.sh"
alias dmemacs="~/.local/lib/python3.9/site-packages/memacs/"

# Uni Files
alias int="cd ~/Dropbox/DokumenteTassilo/intelligenceAmplification/reading/; ranger"

#miscelanous or recently added.
alias vpn="sudo $HOME/vpnstuff"
alias htop="sudo htop"
alias abox="archivebox"
gitdownload() {
    curl -L $(echo "$1" | sed -r 's/https:\/\/github\.com\/(.*)$/git@github.com:\1\/archive\/master.tar.gz/') | tar zxf -
}
