#!/usr/bin/env sh

# launch emacsclient with special frame name
/usr/local/bin/emacs -n -c  --frame-parameters "((name . \"_emacs scratchpad_\"))" "$@"
#i3-msg '[title="_emacs scratchpad_"] move scratchpad' #this might be superflous, because this is already done with all windows of this type (it might also need some deference?"
i3-msg '[title="_emacs scratchpad_"] scratchpad show' 
