#!/bin/bash -   
#title          :emacs-protocol.sh
#description    :executable that is fed emacs-protocol
#author         :Tassilo Neubauer
#date           :20220818
#version        :0.1    
#usage          :./emacs-protocol.sh
#notes          :       
#bash_version   :5.1.16(1)-release
#============================================================================
/usr/local/bin/emacsclient -n -c  --frame-parameters "((name . \"_emacs scratchpad_\"))" "$@"
i3-msg '[title="_emacs scratchpad_"] scratchpad show'
