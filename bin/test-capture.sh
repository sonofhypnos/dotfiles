#!/bin/sh

# launch emacsclient with special frame name
# TODO Figure out why sleep is necessary here?
/usr/local/bin/emacs --frame-parameters="((name . \"_emacs scratchpad_\"))" --eval="(progn (require 'org) (org-capture))" #sleep is added so the program realizes it was successful?
i3-msg '[title="_emacs scratchpad_"] scratchpad show' 
