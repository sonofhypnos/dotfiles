unifiles="$HOME/Dropbox/semester2"
swtfiles="$unifiles/Softwaretechnik\ I\ mit\ Übung/"
lafiles="$unifiles/Lineare\ Algebra\ \ II\ für\ Mathematik/"
algofiles="$unifiles/Algorithmen\ I\ \(SS\ 2021\)/"
hmfiles="$unifiles/0186800\ –\ Höhere\ Mathematik\ II\ \(Analysis\)\ für\ die\ Fachrichtung\ Informatik/"
dgtfiles="$unifiles/24007\ –\ Digitaltechnik\ und\ Entwurfsverfahren/"

#convenience
alias d='cd'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias e='emacsclient -c & disown'
alias gll='git log --graph --pretty=oneline --abbrev-commit'
alias bat='batcat'
alias v='nvim'

# Aliases to protect against overwriting
alias cp='cp -i'
alias mv='mv -i'
alias ainstall='sudo apt-get update -y & sudo apt-get upgrade -y && sudo apt-get install'

#directories
#alias do='cd ~/.dotfiles' this line caused a tone of problems for me.
alias regi3='nvim ~/.dotfiles/config/regolith/i3/config'
alias aalias='nvim ~/.dotfiles/shell/aliases.sh'
alias ozsh='cd ~/.dotfiles/zsh/oh-my-zsh'
alias econfig='nvim ~/.doom.d/config.el'
alias .d='cd /home/tassilo/.dotfiles/'
alias ashell="nvim /home/tassilo/.dotfiles/shell/aliases.sh"
alias dmemacs="~/.local/lib/python3.9/site-packages/memacs/"

########################################
# Uni Files
########################################

alias hm1="xdg-open $unifiles/Höhere\ Mathematik\ I\ \(Analysis\)\ für\ die\ Fachrichtung\ Informatik/Vorlesungsmaterial/Skript\ Höhere\ Mathematik\ 1.pdf && exit" 
alias hm2="xdg-open $unifiles/Höhere\ Mathematik\ I\ \(Analysis\)\ für\ die\ Fachrichtung\ Informatik/Vorlesungsmaterial/HM2.pdf && exit" 

#navigate to ranger
alias rs="cd $unifiles; ranger"
alias hm="cd $hmfiles; ranger"
alias la="cd $lafiles; ranger"
alias swt="cd $swtfiles; ranger"
alias dgt="cd $dgtfiles; ranger"
alias algo="cd $algofiles; ranger"

alias la1="xdg-open semester2/Lineare\ Algebra\ II\ für\ Mathematik/stuff/LA1.pdf && exit"
alias dIlias='exec ~/Installations/KIT-ILIAS-downloader -t -o ~/Dropbox/semester2'
alias update-alternatives='sudo update-alternatives'

#miscelanous or recently added.


sswt() {
	pdfgrep -Ri $1 "$swtfiles"
	grep -Ri $1 "$swtfiles"
}
sla() {
	pdfgrep -Ri $1 "$lafiles"

	grep -Ri $1 "$lafiles"
}
salgo() {
	pdfgrep -Ri $1 "$algofiles"
	grep -Ri $1 "$algofiles"
}
sdgt() {
	pdfgrep -Ri $1 "$dgtfiles"
	grep -Ri $1 "$dgtfiles"
}
shm() {
	pdfgrep -Ri $1 "$hmfiles"
	grep -Ri $1 "$hmfiles"
}


alias vpn='sudo openvpn --config ~/Downloads/kit.ovpn'
