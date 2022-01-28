#!/bin/sh
firstScreen=$(xrandr | grep -v disconnected | grep connected | sed -E 's/.*([[:digit:]]) connected.*/\1/' | head -n 2 | tail -1)
secondScreen=$(xrandr | grep -v disconnected | grep connected | sed -E 's/.*([[:digit:]]) connected.*/\1/' | head -n 3 | tail -1)
echo "xrandr --output eDP --mode 1920x1080 --pos 0x0 --rotate normal --output HDMI-A-0 --off --output DisplayPort-0 --off --output DisplayPort-1 --off --output DisplayPort-$firstScreen --off --output DisplayPort-$secondScreen --off" | xargs xrandr
