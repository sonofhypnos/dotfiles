#!/bin/bash -   
#title          :profile.sh
#description    :profile python code
#author         :Tassilo Neubauer
#date           :20220104
#version        :0.1    
#usage          :./profile.sh
#notes          :       
#bash_version   :5.1.4(1)-release
#============================================================================

python -m cProfile %1
