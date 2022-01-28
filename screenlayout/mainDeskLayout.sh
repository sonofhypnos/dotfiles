#!/bin/sh
firstScreen=$(xrandr | grep -v disconnected | grep connected | sed -E 's/.*([[:digit:]]) connected.*/\1/' | head -n 2 | tail -1)
secondScreen=$(xrandr | grep -v disconnected | grep connected | sed -E 's/.*([[:digit:]]) connected.*/\1/' | head -n 3 | tail -1)
xrandr --output eDP --mode 1920x1080 --pos 0x521 --rotate normal --output HDMI-A-0 --off --output DisplayPort-0 --off --output DisplayPort-1 --off --output DisplayPort-4 --primary --mode 1920x1080 --pos 1920x521 --rotate normal --output DisplayPort-5 --mode 1920x1080 --pos 3840x0 --rotate right
