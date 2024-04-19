#!/usr/bin/sh
# launch emacsclient with special frame name.
# works better than org-capture from doom
set -e
/usr/local/bin/emacsclient -n -c  --frame-parameters "((name . \"_emacs scratchpad_\"))" -e '(org-capture :entry "n")' #sleep is added so the program realizes it was successful?

/usr/bin/i3-msg '[title="_emacs scratchpad_"] scratchpad show'

