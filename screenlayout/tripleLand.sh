#!/usr/bin/env sh
firstScreen=$(xrandr | grep -v disconnected | grep connected | sed -E 's/.*([[:digit:]]) connected.*/\1/' | head -n 2 | tail -1)
secondScreen=$(xrandr | grep -v disconnected | grep connected | sed -E 's/.*([[:digit:]]) connected.*/\1/' | head -n 3 | tail -1)
echo "xrandr --output eDP --mode 1920x1080 --pos 0x502 --rotate normal --output HDMI-A-0 --off --output DisplayPort-0 --off --output DisplayPort-1 --off --output DisplayPort-$firstScreen --primary --mode 1920x1080 --pos 1920x502 --rotate normal --output DisplayPort-$secondScreen --mode 1920x1080 --pos 3840x502 --rotate normal" | xargs xrandr
