#!/bin/bash -   
#title          :scratch_toggle.sh
#description    :Toggles scratchwindow for applications
#author         :Tassilo Neubauer
#date           :20250213
#version        :0.1    
#usage          :./scratch_toggle.sh
#notes          :       
#bash_version   :5.1.16(1)-release
#============================================================================

app_class="$1"
app_cmd="$2"

if ! i3-msg "[class=\"$app_class\"] scratchpad show" | grep -q "true"; then
    exec $app_cmd
fi
