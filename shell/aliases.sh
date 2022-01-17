unifiles2="$HOME/Dropbox/semester2"
unifiles="$HOME/Dropbox/semester3"
lafiles="$unifiles/Lineare\ Algebra\ \ II\ für\ Mathematik/"
osfiles="$unifiles/Betriebssysteme\ WS\ 21-22/"
robfiles="$unifiles/Robotik\ I\ -\ Einführung\ in\ die\ Robotik/"
tgifiles="$unifiles/Theoretische\ Grundlagen\ der\ Informatik/"
cgfiles="$unifiles/Computergrafik\ WS\ 21-22/"
rofiles="$unifiles/24502\ –\ Rechnerorganisation/"
wsfiles="$unifiles/Grundlagen\ der\ Wahrscheinlichkeitstheorie\ und\ Statistik\ für\ Studierende\ der\ Informatik/"
dgtfiles="$unifiles/24007\ –\ Digitaltechnik\ und\ Entwurfsverfahren/"
maineditor='nvim'

#convenience
alias d='cd'
alias ll='ls -alFh'
alias l='ls -CF'
alias e='emacsclient -c'
alias gll='git log --graph --pretty=oneline --abbrev-commit'
alias bat='batcat'
alias v='nvim'
alias pip2='python2 -m pip'
alias printpagesd='lpr -o number-up=2 sides=two-sided-long-edge -P HaDiKo-EUFF'
alias rars="$HOME/Dropbox/semester3/24502\ –\ Rechnerorganisation/Übungsmaterialien/Übung\ 2/rars_46ab74d.jar"
alias mat='MATLAB_JAVA=/home/tassilo/.sdkman/candidates/java/8.0.282.fx-zulu/jre;matlab & disown'

alias refresh='watch -n 1 cat'

# Aliases to protect against overwriting
alias cp='cp -i'
alias mv='mv -i'
alias ainstall='sudo apt-get update -y & sudo apt-get upgrade -y && sudo apt-get install'

#directories and files
#alias do='cd ~/.dotfiles' this line caused a tone of problems for me, because do is a keyword in bash of course
alias regi3='e ~/.dotfiles/config/regolith/i3/config'
alias aalias='$maineditor ~/.dotfiles/shell/aliases.sh'
alias ozsh='cd ~/.dotfiles/zsh/oh-my-zsh'
alias econfig='$maineditor ~/.doom.d/config.el'
alias .d='cd /home/tassilo/.dotfiles/'
alias ashell="$maineditor /home/tassilo/.dotfiles/shell/aliases.sh"
alias dmemacs="~/.local/lib/python3.9/site-packages/memacs/"

# Uni Files
alias hm1="xdg-open ~/Dropbox/semester2/Höhere\ Mathematik\ I\ \(Analysis\)\ für\ die\ Fachrichtung\ Informatik/Vorlesungsmaterial/Skript\ Höhere\ Mathematik\ 1.pdf && exit" 
alias hm2="xdg-open $unifiles2/Höhere\ Mathematik\ I\ \(Analysis\)\ für\ die\ Fachrichtung\ Informatik/Vorlesungsmaterial/HM2.pdf && exit" 


#navigate to ranger
alias os="cd $osfiles ; ranger"
alias ro="cd $rofiles ; ranger"
alias rob="cd $robfiles ; ranger"
alias ws="cd $wsfiles ; ranger"
alias tgi="cd $tgifiles ; ranger"
alias cg1="cd $cgfiles ; ranger"
alias rs="cd $unifiles ; ranger"
alias hm="cd $hmfiles ; ranger"
alias la="cd $lafiles ; ranger"
alias swt="cd $swtfiles ; ranger"
alias dgt="cd $dgtfiles ; ranger"
alias algo="cd $algofiles ; ranger"
alias ot="cd $HOME/repos/oTree/ ; ranger"


alias la1="xdg-open semester2/Lineare\ Algebra\ II\ für\ Mathematik/stuff/LA1.pdf && exit"
alias dIlias='exec ~/Installations/KIT-ILIAS-downloader -t -o ~/Dropbox/semester2'
alias update-alternatives='sudo update-alternatives'

#miscelanous or recently added.
alias vpn="sudo $HOME/vpnstuff"
alias htop="sudo htop"
alias abox="archivebox"
