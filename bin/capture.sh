#!/usr/bin/env bash
# launch emacsclient with special frame name.
# works better than org-capture from doom
set -e
/usr/local/bin/emacsclient -n -c  --frame-parameters "((name . \"_emacs scratchpad_\"))" -e '(org-capture :entry "n")' #sleep is added so the program realizes it was successful?

i3-msg '[title="_emacs scratchpad_"] scratchpad show'

#make_visible (){
##    wid="$(xdotool search --classname "${name}" | tail -1 2> /dev/null)"
##    echo $(expr length "${wid}")
#    while ! i3-msg "[title=\"doom-capture\"] scratchpad show"; do
#	sleep 0.05;
#    done
#}
## Wait for application to be available
#cleanup(){
#    org-capture "$@"
##i3-msg '[title="doom-capture"] move scratchpad'
##        i3-msg '[title="doom-capture"] floating disable'
##        i3-msg '[title="doom-capture"] floating enable'
#}
#
#make_visible & cleanup "$@"

# i3-msg '[title="doom-capture"] move scratchpad'
# i3-msg '[title="_emacs scratchpad_"] scratchpad show'
