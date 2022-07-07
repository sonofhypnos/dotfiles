#!/bin/sh

# launch emacsclient with special frame name
# TODO Figure out why sleep is necessary here?
#/usr/local/bin/emacsclient -n -c  --frame-parameters "((name . \"_emacs scratchpad_\"))" -e '(org-capture :entry "n")' #sleep is added so the program realizes it was successful?
org-capture "$@"
i3-msg '[title="doom-capture"] move scratchpad'
i3-msg '[title="doom-capture"] scratchpad show'
i3-msg '[title="_emacs scratchpad_"] scratchpad show'

