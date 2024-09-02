#!/bin/bash -   
#title          :logwatch-notify.sh
#description    :Notify me of problems on my system
#author         :Tassilo Neubauer
#date           :20240902
#version        :0.1    
#usage          :./logwatch-notify.sh
#notes          :       
#bash_version   :5.1.16(1)-release
#============================================================================

# Run Logwatch and capture its output
LOGWATCH_OUTPUT=$(sudo /usr/sbin/logwatch --output stdout --format text --range yesterday --detail low)

# Check if the output contains any warnings or errors
if echo "$LOGWATCH_OUTPUT" | grep -qiE 'warning|error|critical|fail'; then
    # If issues found, send a notification
    sudo -u tassilo DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u tassilo)/bus notify-send -u critical "Logwatch Alert" "Potential issues detected in system logs. Check full report under /home/tassilo/logwatch_report.txt for details."
fi

# Save the full report to a file in tassilo's home directory
echo "$LOGWATCH_OUTPUT" > /home/tassilo/logwatch_report.txt
chown tassilo:tassilo /home/tassilo/logwatch_report.txt
