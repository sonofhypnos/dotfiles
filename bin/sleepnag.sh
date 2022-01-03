#!/bin/bash -   
#title          :sleepnag.sh
#description    :Remind me that sleep is important. Maybe enable auto-shutdown as well.
#author         :Tassilo Neubauer
#date           :20220103
#version        :0.1    
#usage          :./sleepnag.sh
#notes          :       
#bash_version   :5.1.4(1)-release
#============================================================================

reminder="You might think that you'll never do the task if you don't stay up to do it. If the task really is that important, you _will_ do it later; if the task isn't, then sleep is more important"
nowcounter=0
shutdownsoon(){
    shutdown 4
}

justifywhyawake(){
    capture.sh
    (( nowcounter+=1 ))
    if [[ $nowcounter -eq 10 ]]; then
        shutdownsoon
    fi
    sleep 300
}


while :; do
    currenttime=$(date +%H:%M)
    if [[ "$currenttime" > "23:00" ]] || [[ "$currenttime" < "06:30" ]]; then
        rofi -e "$reminder";
        $(printf 'shutdownsoon\njustifywhyawake' | rofi -dmenu)
        #could do fancy stuff here, but I don't know how to do arrays in bash (eg dictionaries would be nice)
    else
    nowcounter=0
    fi
    sleep 300
done
