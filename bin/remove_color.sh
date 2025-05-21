#!/usr/bin/env bash   
#title          :remove_color.sh
#description    :removes color from output
#author         :Tassilo Neubauer
#date           :20240522
#version        :0.1    
#usage          :./remove_color.sh
#notes          :       
#bash_version   :5.1.16(1)-release
#============================================================================

sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2};?)?)?[mGK]//g"
