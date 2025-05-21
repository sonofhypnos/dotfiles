#!/usr/bin/env bash   
#title          :evening_routine.sh
#description    :Starts evening routine script
#author         :Tassilo Neubauer
#date           :20241115
#version        :0.1    
#usage          :./evening_routine.sh
#notes          :       
#bash_version   :5.1.16(1)-release
#============================================================================

/usr/local/bin/emacsclient -n -c -a "" --frame-parameters "((name . \"_emacs scratchpad_\"))" -e "(org-roam-dailies-goto-today)" && i3-msg '[title="_emacs scratchpad_"] scratchpad show'
