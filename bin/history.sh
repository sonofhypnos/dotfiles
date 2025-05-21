#!/usr/bin/env bash   
#title          :history.sh
#description    :copy over history files
#author         :Tassilo Neubauer
#date           :20220427
#version        :0.1    
#usage          :./history.sh
#notes          :       
#bash_version   :5.1.4(1)-release
#============================================================================

TEMP=$(mktemp -d)
dirs=$(ls -d ~/.mozilla/firefox/* | grep default)
 for dir in $dirs; do
     d=$(basename $dir)
      (mkdir -p "$TEMP/$d" && cp $dir/places.sqlite "$TEMP/$d/places.sqlite") || logger "$0 $d directory could not be created"
 done
