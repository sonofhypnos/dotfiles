#!/bin/bash -
#title          :enable_user_services.sh
#description    :Enables user services
#author         :Tassilo Neubauer
#date           :20250316
#version        :0.1
#usage          :./enable_user_services.sh
#notes          :
#bash_version   :5.1.16(1)-release
#============================================================================

# Add systemd timer setup
SYSTEMD_SERVICE_FILE="./config/systemd/user/writing_tracker.service"
SYSTEMD_TIMER_FILE="./config/systemd/user/writing_tracker.timer"

if [ -f "$SYSTEMD_SERVICE_FILE" ] && [ -f "$SYSTEMD_TIMER_FILE" ]; then
    echo "starting to enable writing_tracker script."
    systemctl --user enable writing-tracker.service
    systemctl --user enable writing-tracker.timer
    systemctl --user start writing-tracker.timer
    echo "Systemd timer enabled and started."
else
    echo "Error: Missing systemd service or timer file."
fi
