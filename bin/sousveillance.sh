#!/bin/bash -   
#title          :sousveillance.sh
#description    :Monitor my laptop behaviour
#author         :Gwern Branwen
#date           :20240517
#version        :0.1    
#usage          :./sousveillance.sh
#notes          :Copied from here: https://www.lesswrong.com/posts/MhWjxybo2wwowTgiA/anti-akrasia-remote-monitoring-experiment#n7HvFWHQZPLAc7ZX8
#bash_version   :5.1.16(1)-release
#============================================================================

set -e

if grep open /proc/acpi/button/lid/LID/state > /dev/null
then
    CURRENT=$(date +%s);
    SLEEP=$(( $CURRENT % 10 ))
    TIMEOUT="m"
    sleep $SLEEP$TIMEOUT
    import -quality 100 -window root png:$HOME/Pictures/webcam/xwd-$CURRENT.png
    fswebcam --resolution 1280x1024 -S 2 -F 3 "$HOME/Pictures/webcam/$CURRENT.jpg"
    optipng -o9 -fix `ls -t ~/Pictures/webcam/*.png | head -1`
    jpegoptim -m50 `ls -t ~/Pictures/webcam/*.jpg | head -1`
fi
