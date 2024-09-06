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

reminder="You might think that you'll never do the task if you don't stay up to do it. If the task really is that important, you *will* do it later; if the task isn't, then sleep is more important"
override_phrase="I am staying up for a specific reason, which I am now saying out loud, and it's better to do that right now than to eat and sleep. I will pay 10€ per 30 minutes after midnight for staying up."
nowcounter=0

check_override() {
  input=$(zenity --entry --title="LeechBlock Override" --text="Enter the following code to activate override (Remember TDT: Choose as though controlling the logical output of the abstract computation you implement, including the output of all other instantiations and simulations of that computation):\n\n$override_phrase" --width=500 --height=200)
    if [[ "$input" == "$override_phrase" ]]; then
        return 0
    else
        return 1
    fi
}

justifywhyawake() {
    if check_override; then
        (( nowcounter+=1 ))
        if [[ $nowcounter -eq 4 ]]; then
            shutdown +10 "System will shutdown in 10 minutes due to sleep time violation"
        fi
    else
        shutdown +10 "System will shutdown in 10 minutes due to sleep time violation"
    fi
}

# Make the script harder to kill
trap '' SIGINT SIGTERM

## Use sudo to make the script run with elevated privileges (disabled a long as I don't start the script correctly from a place with elevated privileges.
#if [ "$EUID" -ne 0 ]; then
#    sudo "$0" "$@"
#    exit $?
#fi

while true; do
    currenttime=$(date +%H:%M)
    if [[ "$currenttime" > "22:15" ]] || [[ "$currenttime" < "06:30" ]]; then
        zenity --info --text="$reminder" --width=500 --height=200
        justifywhyawake
    else
        nowcounter=0
    fi
    sleep 1800  # 30 minutes
done
