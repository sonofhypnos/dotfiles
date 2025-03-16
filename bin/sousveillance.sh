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

if grep open /proc/acpi/button/lid/LID/state >/dev/null; then
    echo "Lid is open"
    HOME="/home/tassilo"
    # CURRENT=$(date +%s);
    # SLEEP=$(( $CURRENT % 10 ))
    # TIMEOUT="m"
    # sleep $SLEEP$TIMEOUT
    gnome-screenshot "$HOME/Pictures/webcam/screenshot-$(date +%s).png"
    echo "current: $CURRENT"
    # fswebcam --resolution 1280x1024 -S 2 -F 3 "$HOME/Pictures/webcam/$CURRENT.jpg"
    # optipng -o9 -fix `ls -t $HOME/Pictures/webcam/*.png | head -1` (compression doesn't seem worth the CPU time)
    # jpegoptim -m50 `ls -t $HOME/Pictures/webcam/*.jpg | head -1`
fi
