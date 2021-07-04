unifiles="$HOME/Dropbox/semester2"
swtfiles="$unifiles/Softwaretechnik\ I\ mit\ Übung"
lafiles="$unifiles/Lineare\ Algebra\ \ II\ für\ Mathematik/"
algofiles="$unifiles/Algorithmen\ I\ \(SS\ 2021\)/"
hmfiles="$unifiles/0186800\ –\ Höhere\ Mathematik\ II\ \(Analysis\)\ für\ die\ Fachrichtung\ Informatik/"
dgtfiles="$unifiles/24007\ –\ Digitaltechnik\ und\ Entwurfsverfahren/"

alias d='cd'

# Aliases to protect against overwriting
alias cp='cp -i'
alias mv='mv -i'


# Editors
alias v='nvim'
alias e='emacsclient --no-wait'
alias gll='git log --graph --pretty=oneline --abbrev-commit'
alias f='fdfind'

#directories
#alias do='cd ~/.dotfiles' this line caused a tone of problems for me.
alias regi3='nvim ~/.dotfiles/config/regolith/i3/config'
alias ozsh='cd ~/.dotfiles/zsh/oh-my-zsh'
alias econfig='nvim ~/.doom.d/config.el'
alias .d='cd /home/tassilo/.dotfiles/'
alias ashell="nvim /home/tassilo/.dotfiles/shell/aliases.sh"

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
alias oIlias='source oIlias'
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


