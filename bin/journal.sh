#!/bin/bash -   
#title          :journal.sh
#description    :Capture Journal Entry in Emacs
#author         :Tassilo Neubauer
#date           :20220121
#version        :0.1    
#usage          :./journal.sh
#notes          :       
#bash_version   :5.1.4(1)-release
#============================================================================

/usr/local/bin/emacsclient -n -c  --frame-parameters "((name . \"_emacs scratchpad_\"))" -e "(org-roam-dailies-capture-today)"
i3-msg '[title="_emacs scratchpad_"] scratchpad show'
