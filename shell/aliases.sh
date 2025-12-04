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
alias evim='echo -n "e)macs or v)im? "; read -k1 c; echo; [[ $c == "e" ]] && emacsclient || vim'
# alias editor='emacsclient 2>/dev/null || emacs 2>/dev/null || vim'

alias refresh='watch -n 1 cat'

# Aliases to protect against overwriting
alias cp='cp -i'
alias mv='mv -i'
alias rm='echo "use trash instead you moron!";rm'
alias ainstall='sudo -A apt-get update -y & sudo -A apt-get upgrade -y && sudo -A apt-get install'

#directories and files
#alias do='cd ~/.dotfiles' NOTE: this line caused a tone of problems for me, because do is a keyword in bash of course
alias emacsclient="emacsclient -a vim"
alias regi3="emacsclient -t ~/.dotfiles/config/regolith3/i3/config.d/45_custom_config"
alias ehome="emacsclient -t ~/.dotfiles/config/home-manager/home.nix"
alias aalias='emacsclient -t ~/.dotfiles/shell/aliases.sh'
alias ozsh='cd ~/.dotfiles/zsh/oh-my-zsh'
alias econfig='vim ~/.doom.d/config.el'
alias .d='cd ~/.dotfiles/'
alias .home='cd ~/.dotfiles/config/home-manager'
alias home-manager-switch='cd ~/.dotfiles/config/home-manager;home-manager switch -b backup --flake .#tassilo'
alias ashell="vim ~/.dotfiles/shell/aliases.sh"
alias dmemacs="~/.local/lib/python3.9/site-packages/memacs/"
alias vastai-ssh="ssh -i ~/.ssh/vastai -o IdentitiesOnly=yes -A"
alias aws-ssh="ssh -i ~/.ssh/aws-e184.pem -o IdentitiesOnly=yes -A" # NOTE: if you are tempted to alias to a different key, you opened your instance in the wrong region!

# Uni Files
alias int="cd ~/Dropbox/DokumenteTassilo/intelligenceAmplification/reading/; ranger"

#miscelanous or recently added.
alias vpn="sudo -A $HOME/vpnstuff"
#alias htop="sudo -A htop"
#alias sudo='sudo -A' #We added this in order to require passwords to go via askpass, which would be useful down the line, if we wanted to send all our keybinds except from askpass and 1password to llms.
alias abox="archivebox"
gitdownload() {
    curl -L $(echo "$1" | sed -r 's/https:\/\/github\.com\/(.*)$/git@github.com:\1\/archive\/master.tar.gz/') | tar zxf -
}

alias ranger='ranger . .'
