#!/bin/bash -   
#title          :sleepnag.sh
#description    :Remind me that sleep is important. Maybe enable auto-shutdown as well.
#author         :Tassilo Neubauer
#date           :20220103
#version        :0.1    
#usage          :./sleepnag.sh
#notes          : I used to have a "Justified" variable in this script. But I removed it again, because it was non-obvious how to actually check that I actually did that?
#bash_version   :5.1.4(1)-release
#============================================================================

reminder="You might think that you'll never do the task if you don't stay up to do it. If the task really is that important, you _will_ do it later; if the task isn't, then sleep is more important"
nowcounter=0


shutdownsoon(){
    shutdown 4 # Early enough to trigger before the sleep timer in the justifywhyawake function is over.
}

justifywhyawake(){
    capture.sh
    (( nowcounter+=1 ))
    if [[ $nowcounter -eq 10 ]]; then
        shutdownsoon
    else
        shutdown 15 #Long enough that we are asking about the reason for not shutting down yet again.
    fi
    sleep 300
}


while :; do
    currenttime=$(date +%H:%M)
    if [[ "$currenttime" > "22:15" ]] || [[ "$currenttime" < "06:30" ]]; then
        rofi -e "$reminder";
        shutdown 2 #We add it here also, in order to force the user to interact with the program.
        #printf 'shutdownsoon\njustifywhyawake' | rofi -dmenu
        selection=$(printf 'Shutdown Soon and Justify Why Awake\nShutdown Now' | rofi -dmenu -p "Select an action:")

        case $selection in
          "Shutdown Soon and Justify Why Awake")
            justifywhyawake
            ;;
          "Shutdown Now")
            shutdown 0
            ;;
        esac
    else
        nowcounter=0
    fi
    sleep 300
done
