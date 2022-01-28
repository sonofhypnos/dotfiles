#!/bin/sh 
firstScreen=$(xrandr | grep -v disconnected | grep connected | sed -E 's/.*([[:digit:]]) connected.*/\1/' | head -n 2 | tail -1)
secondScreen=$(xrandr | grep -v disconnected | grep connected | sed -E 's/.*([[:digit:]]) connected.*/\1/' | head -n 3 | tail -1)
echo "--output eDP --mode 1920x1080 --pos 0x502 --rotate normal --output DisplayPort-$firstScreen --primary --mode 1920x1080 --pos 1920x0 --rotate left --output DisplayPort-$secondScreen --mode 1920x1080 --pos 3000x0 --rotate right" | xargs xrandr
