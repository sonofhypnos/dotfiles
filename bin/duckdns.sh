#!/usr/bin/env bash   
#title          :duckdns.sh
#description    :New Duck DNS
#author         :Tassilo Neubauer
#date           :20240621
#version        :0.1    
#usage          :./duckdns.sh
#notes          :       
#bash_version   :5.1.16(1)-release
#============================================================================


pwd=$(runuser -l tassilo -c 'DISPLAY=:0; export DISPLAY;rofi -dmenu -password -lines 1 -p "Enter 1Password password"')
op whoami || eval "$(echo "$pwd" | op signin)"
# Retrieve the DuckDNS token from 1Password
DUCKDNS_TOKEN=$(op item get "DuckDNS Token" --vault "Personal" --fields notesPlain)

# Update DuckDNS
echo url="https://www.duckdns.org/update?domains=tassilo&token=${DUCKDNS_TOKEN}&ip=" | curl -k -o /home/tassilo/duck.log -K -
