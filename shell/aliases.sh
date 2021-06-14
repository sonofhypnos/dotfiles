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
#miscelanous or recently added.
alias .d='cd /home/tassilo/.dotfiles/'
alias ashell='nvim /home/tassilo/.dotfiles/shell/aliases.sh'
alias hm='xdg-open semester2/Höhere\ Mathematik\ I\ \(Analysis\)\ für\ die\ Fachrichtung\ Informatik/Vorlesungsmaterial/Skript\ Höhere\ Mathematik\ 1.pdf && exit' 
alias hm1='xdg-open semester2/Höhere Mathematik I (Analysis) für die Fachrichtung Informatik/Vorlesungsmaterial/Skript Höhere Mathematik 1.pdf && exit'
alias rs='cd ~/Dropbox/semester2; ranger'
alias la1='xdg-open semester2/Lineare\ Algebra\ II\ für\ Mathematik/stuff/LA1.pdf && exit'
alias oIlias='source oIlias'
alias update-alternatives='sudo update-alternatives'

function usswt {
alias usswt="pdfgrep -Ri $@ ~/Dropbox/semester2/Softwaretechnik\ I\ mit\ Übung"
}
function usla {
alias usswt="pdfgrep -Ri $@ ~/Dropbox/semester2/Lineare\ Algebra\ II\ für\ Mathematik"
}
function usalgo {
alias usswt="pdfgrep -Ri $@ ~/Dropbox/semester2/Algorithmen\ I\ (SS\ 2021)"
}
function ushm {
alias usswt="pdfgrep -Ri $@ ~/Dropbox/semester2/0186800\ –\ Höhere\ Mathematik\ II\ (Analysis)\ für\ die\ Fachrichtung\ Informatik"
}
function usdgt {
alias usswt="pdfgrep -Ri $@ ~/Dropbox/semester2/24007\ –\ Digitaltechnik\ und\ Entwurfsverfahren"
}




