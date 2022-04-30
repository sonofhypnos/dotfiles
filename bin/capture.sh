#!/bin/sh

# launch emacsclient with special frame name
# TODO Figure out why sleep is necessary here?
/usr/local/bin/emacsclient -n -c  --frame-parameters "((name . \"_emacs scratchpad_\"))" -e "(org-capture)" &
sleep 0.3
i3-msg '[title="_emacs scratchpad_"] scratchpad show' 
