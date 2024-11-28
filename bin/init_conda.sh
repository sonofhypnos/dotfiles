#!/bin/bash -
#title          :init_conda.sh
#description    :Initialize conda in the current shell
#author         :Tassilo Neubauer
#date           :20241121
#version        :0.1    
#usage          :./init_conda.sh
#notes          :       
#bash_version   :5.1.16(1)-release
#============================================================================

if [ -f "/home/tassilo/miniconda3/etc/profile.d/conda.sh" ]; then
    . "/home/tassilo/miniconda3/etc/profile.d/conda.sh"
else
    export PATH="/home/tassilo/miniconda3/bin:$PATH"
fi
