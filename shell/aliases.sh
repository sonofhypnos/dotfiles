unifiles2="$HOME/Dropbox/semester2"
#unifiles="$HOME/Dropbox/semester3"
unifiles="$HOME/Dropbox/semester6"
unifiles5="$HOME/Dropbox/semester5"
unifiles6="$HOME/Dropbox/semester6"
mphfiles="$unifiles/4040451\ –\ Moderne\ Physik\ für\ Informatiker"
cvxfiles="$unifiles5/convex_optimization/"
pgfiles="$unifiles6/24614\ –\ Algorithmen\ für\ planare\ Graphen\ \(mit\ Übungen\)"

#convenience
alias d='cd'
alias p='popd'
alias ll='ls -alFh'
alias l='ls -CF'
alias e='emacsclient -c'
alias less='less -R'
alias gll='git log --graph --pretty=oneline --abbrev-commit'
alias bat='batcat'
alias v="nvim"
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
alias regi3='vim ~/.dotfiles/config/regolith2/i3/config.d/40_workspace-config'
alias aalias='emacsclient ~/.dotfiles/shell/aliases.sh'
alias ozsh='cd ~/.dotfiles/zsh/oh-my-zsh'
alias econfig='vim ~/.doom.d/config.el'
alias .d='cd ~/.dotfiles/'
alias ashell="vim ~/.dotfiles/shell/aliases.sh"
alias dmemacs="~/.local/lib/python3.9/site-packages/memacs/"

# Uni Files
alias hm1="xdg-open ~/Dropbox/semester2/Höhere\ Mathematik\ I\ \(Analysis\)\ für\ die\ Fachrichtung\ Informatik/Vorlesungsmaterial/Skript\ Höhere\ Mathematik\ 1.pdf && exit"
alias hm2="xdg-open $unifiles2/Höhere\ Mathematik\ I\ \(Analysis\)\ für\ die\ Fachrichtung\ Informatik/Vorlesungsmaterial/HM2.pdf && exit"

alias rs="cd $unifiles ; ranger"
alias mph="xdg-open $mphfiles/Vorlesung-Skript/VL.pdf  ; ranger"
alias cvx="cd $cvxfiles ; ranger"
alias txt="cd ~/Dropbox/textbooks/ ; ranger"
alias ml="zathura ~/Dropbox/textbooks/machine\ learning\ from\ theory\ to\ algorithms.pdf"
alias pg="cd $pgfiles ; ranger"

alias la1="xdg-open semester2/Lineare\ Algebra\ II\ für\ Mathematik/stuff/LA1.pdf && exit"
alias dIlias='exec ~/Installations/KIT-ILIAS-downloader -t -o ~/Dropbox/semester2'
alias update-alternatives='sudo update-alternatives'

#miscelanous or recently added.
alias vpn="sudo $HOME/vpnstuff"
alias htop="sudo htop"
alias abox="archivebox"
gitdownload() {
	curl -L $(echo "$1" | sed -r 's/https:\/\/github\.com\/(.*)$/git@github.com:\1\/archive\/master.tar.gz/') | tar zxf -
}
