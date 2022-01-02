#!/bin/bash -   
#title          :github-clone.sh
#description    :Use git clone with ssh instead of http address
#author         :Tassilo Neubauer
#date           :20211208
#version        :0.1    
#usage          :./github-clone.sh
#notes          :       
#bash_version   :5.1.4(1)-release
#============================================================================

echo "$1" | sed 's/.*github.com\//git@github.com:/' | sed 's/$/.git/' | xargs git clone --recurse-submodules
