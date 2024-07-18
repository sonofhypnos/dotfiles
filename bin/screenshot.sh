#!/bin/bash -   
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

# Convert the PNG file to JPEG format
mogrify -format jpg /tmp/screenshot.png

# Copy the JPEG file to the clipboard
xclip -selection clipboard -t image/jpeg -i /tmp/screenshot.jpg

# Optionally, remove the temporary files
rm /tmp/screenshot.png /tmp/screenshot.jpg
