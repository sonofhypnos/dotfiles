#!/bin/bash -   
#title          :synch_org-roam.sh
#description    :push org-roam stuff to remote
#author         :Tassilo Neubauer
#date           :20220102
#version        :0.1    
#usage          :./synch_org-roam.sh
#notes          :       
#bash_version   :5.1.4(1)-release
#============================================================================

cd "$HOME/org-roam/" || echo 'Error! Org-roam directory does not exist.'
git push origin
