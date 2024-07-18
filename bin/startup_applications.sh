#!/bin/zsh -
#title          :startup_applications.sh
#description    :Startup my applications
#author         :Tassilo Neubauer
#date           :20240713
#version        :0.1    
#usage          :./startup_applications.sh
#notes          :       
#bash_version   :5.1.16(1)-release
#============================================================================

# Essential, quick-start applications
emacs --daemon; emacsclient -c &
sleep 2

# System utilities and less resource-intensive apps
i3-wallpaper &
sleep 2
copyq &
sleep 5

# AI:
google-chrome --app=https://claude.ai &
sleep 5
google-chrome --app=https://chat.openai.com/?model=gpt-4 &
sleep 5


# Low prio:
~/bin/sleepnag.sh &
sleep 2
rescuetime &
sleep 2
flameshot &
sleep 2

# More resource-intensive applications
# Not using zotero right now:
#flatpak run org.zotero.Zotero &
#sleep 10

# Web applications (Chrome)
sleep 30

# Firefox (heaviest, started last)
firefox https://arena3-chapter0-fundamentals.streamlit.app &
sleep 20
firefox https://arena3-chapter1-transformer-interp.streamlit.app/ &
