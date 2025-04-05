#!/bin/bash -   
#title          :logwatch-notify.sh
#description    :Notify me of problems on my system
#author         :Tassilo Neubauer
#date           :20250406
#version        :0.2
#usage          :./logwatch-notify.sh
#notes          :       
#bash_version   :5.1.16(1)-release
#============================================================================

# Set the log directory path
LOG_DIR="/home/tassilo/logwatch_reports"

# Create the log directory if it doesn't exist
if [ ! -d "$LOG_DIR" ]; then
    mkdir -p "$LOG_DIR"
    chown tassilo:tassilo "$LOG_DIR"
fi

# Create a timestamped filename for today's report
TIMESTAMP=$(date +"%Y-%m-%d")
REPORT_FILE="$LOG_DIR/logwatch_$TIMESTAMP.txt"

# Create a symlink for the most recent report
LATEST_LINK="/home/tassilo/logwatch_report.txt"

# Run Logwatch and capture its output
LOGWATCH_OUTPUT=$(sudo /usr/sbin/logwatch --output stdout --format text --range yesterday --detail low)

# Check if the output contains any warnings or errors
if echo "$LOGWATCH_OUTPUT" | grep -qiE 'warning|error|critical|fail'; then
    # If issues found, send a notification
    sudo -u tassilo DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u tassilo)/bus notify-send -u critical "Logwatch Alert" "Potential issues detected in system logs. Check full report under $LATEST_LINK for details."
fi

# Save the full report to the timestamped file
echo "$LOGWATCH_OUTPUT" > "$REPORT_FILE"
chown tassilo:tassilo "$REPORT_FILE"

# Update the symlink to point to the latest report
ln -sf "$REPORT_FILE" "$LATEST_LINK"
chown -h tassilo:tassilo "$LATEST_LINK"
