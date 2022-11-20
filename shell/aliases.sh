unifiles2="$HOME/Dropbox/semester2"
#unifiles="$HOME/Dropbox/semester3"
unifiles="$HOME/Dropbox/semester4"
unifiles5="$HOME/Dropbox/semester5"
lafiles="$unifiles2/Lineare\ Algebra\ \ II\ für\ Mathematik/"
osfiles="$unifiles/Betriebssysteme\ WS\ 21-22/"
robfiles="$unifiles/Robotik\ I\ -\ Einführung\ in\ die\ Robotik/"
tgifiles="$unifiles/Theoretische\ Grundlagen\ der\ Informatik/"
cgfiles="$unifiles/Computergrafik\ WS\ 21-22/"
rofiles="$unifiles/24502\ –\ Rechnerorganisation/"
wsfiles="$unifiles/Grundlagen\ der\ Wahrscheinlichkeitstheorie\ und\ Statistik\ für\ Studierende\ der\ Informatik/"
dgtfiles="$unifiles2/24007\ –\ Digitaltechnik\ und\ Entwurfsverfahren/"
progfiles="$unifiles/24004\ –\ Programmieren/"
dsfiles="$unifiles/24516\ –\ Datenbanksysteme"
ksfiles="$unifiles/24572\ –\ Kognitive\ Systeme"
icfiles="$unifiles/24872\ –\ Basispraktikum\ zum\ ICPC\ Programmierwettbewerb\ -\ SS\ 2022"
icpcfiles="$unifiles5/24872\ –\ Basispraktikum\ zum\ ICPC\ Programmierwettbewerb\ -\ SS\ 2022"
cg23files="$unifiles/Computergrafik\ WS\ 22-23/"
ph2files="$unifiles5/Physik\ II\ für\ Informatiker\ \(WS22-23\)"
mphfiles="$unifiles/4040451\ –\ Moderne\ Physik\ für\ Informatiker"
nmffiles="$unifiles/Numerische\ Mathematik\ \ für\ die\ Fachrichtungen\ Informatik\ und\ Ingenieurwesen\ \(SS22\)"
rnfiles="$unifiles/Einführung\ in\ Rechnernetze"
propafiles="$unifiles5/24030\ –\ Programmierparadigmen/"

#convenience
alias d='cd'
alias p='popd'
alias ll='ls -alFh'
alias l='ls -CF'
alias e='emacsclient -c'
alias gll='git log --graph --pretty=oneline --abbrev-commit'
alias bat='batcat'
alias v="nvim"
alias pip2='python2 -m pip'
alias printpagesd='lpr -o number-up=2 sides=two-sided-long-edge -P HaDiKo-EUFF'
alias rars="$HOME/Dropbox/semester3/24502\ –\ Rechnerorganisation/Übungsmaterialien/Übung\ 2/rars_46ab74d.jar"
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
alias aalias='vim ~/.dotfiles/shell/aliases.sh'
alias ozsh='cd ~/.dotfiles/zsh/oh-my-zsh'
alias econfig='vim ~/.doom.d/config.el'
alias .d='cd ~/.dotfiles/'
alias ashell="vim ~/.dotfiles/shell/aliases.sh"
alias dmemacs="~/.local/lib/python3.9/site-packages/memacs/"

# Uni Files
alias hm1="xdg-open ~/Dropbox/semester2/Höhere\ Mathematik\ I\ \(Analysis\)\ für\ die\ Fachrichtung\ Informatik/Vorlesungsmaterial/Skript\ Höhere\ Mathematik\ 1.pdf && exit"
alias hm2="xdg-open $unifiles2/Höhere\ Mathematik\ I\ \(Analysis\)\ für\ die\ Fachrichtung\ Informatik/Vorlesungsmaterial/HM2.pdf && exit"

alias icpc="cd $icpcfiles ; ranger"
alias ph2="cd $ph2files ; ranger"
alias propa="cd $propafiles ; ranger"
alias os="cd $osfiles ; ranger"
alias prog="cd $progfiles ; ranger"
alias ro="cd $rofiles ; ranger"
alias rob="cd $robfiles ; ranger"
alias ws="cd $wsfiles ; ranger"
alias tgi="cd $tgifiles ; ranger"
alias cg1="cd $cgfiles ; ranger"
alias cg23="cd $cg23files ; ranger"
alias rs="cd $unifiles ; ranger"
alias hm="cd $hmfiles ; ranger"
alias la="cd $lafiles ; ranger"
alias swt="cd $swtfiles ; ranger"
alias dgt="cd $dgtfiles ; ranger"
alias algo="cd $algofiles ; ranger"
alias ot="cd $HOME/repos/oTree/ ; ranger"
alias ds="cd $dsfiles  ; ranger"
alias kog="cd $ksfiles  ; ranger"
alias ic="cd $icfiles  ; ranger"
alias mph="cd $mphfiles ; ranger"
alias nmf="cd $nmffiles ; ranger"
alias rn="cd $rnfiles  ; ranger"
alias txt="cd ~/Dropbox/textbooks/ ; ranger"
alias ml="zathura ~/Dropbox/textbooks/machine\ learning\ from\ theory\ to\ algorithms.pdf"

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
