#!/usr/bin/env bash   
#title          :screenshot.sh
#description    :make screenshots
#author         :Tassilo Neubauer
#date           :20240523
#version        :0.1    
#usage          :./screenshot.sh
#notes          :       
#bash_version   :5.1.16(1)-release
#============================================================================

# Take a screenshot of a selected region and save it as a PNG file
gnome-screenshot -a -f /tmp/screenshot.png

# Copy the PNG file to the clipboard
xclip -selection clipboard -t image/png -i /tmp/screenshot.png

# Optionally, remove the temporary files
rm /tmp/screenshot.png
