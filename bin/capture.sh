#!/bin/sh

# launch emacsclient with special frame name
/usr/local/bin/emacsclient -n -c  --frame-parameters "((name . \"_emacs scratchpad_\"))" -e "(org-capture)" 
i3-msg '[title="_emacs scratchpad_"] scratchpad show' 
