#!/usr/bin/env bash   
#title          :compile-config.sh
#description    :Compiles config and removes todo from readme.org. Takes the file of the configuration as input. Default is ~/.doom.d
#author         :Tassilo Neubauer
#date           :20210923
#version        :1.0    
#usage          :./compile-config.sh
#notes          :       
#bash_version   :5.1.4(1)-release
#============================================================================

cd "${1:-$HOME/.doom.d/}" || echo compile config was not able to run && exit
yes | doom compile & cp config.org README.org && sed -i '/^[^\"]*TODO[^\"]*$/d' README.org
