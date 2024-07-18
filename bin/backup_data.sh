#!/bin/bash -
#title          :backup_data.sh
#description    :Backup data from laptop to pc
#author         :Tassilo Neubauer
#date           :20220102
#version        :0.9
#usage          :./backup_data.sh
#notes          :
#bash_version   :5.1.4(1)-release
#============================================================================

# User-configurable constants
# ============================
# Modify these variables to customize the script for your setup

# The user who will receive GUI prompts
GUI_USER="tassilo"

# The repository URL for your Borg backup
BORG_REPO="ssh://d7h5sb0u@borgbase/./repo"

# The path to the log file for storing the last successful archive date
LAST_ARCHIVE_LOG="/var/log/borg_last_archive.log"

# The 1Password item path for the Borg passphrase (Or adjust code to whichever way you handle secrets.)
BORG_PASSPHRASE_1PASSWORD_PATH="op://Personal/Encryption borg base laptop passphrase/password"

# Directories and files to exclude from the backup
# Add or remove paths as needed
EXCLUDE_PATTERNS=(
    '/home/**/.cache/**'
    '/home/**/.Cache/**'
    '/home/**/cache/**'
    '/home/**/Cache/**'
    '/home/**/CacheStorage/**'
    '/home/**/CachedData/**'
    '/home/tassilo/Dropbox/**'
    '/home/tassilo/Games/'
    '/home/**/Code Cache/**'
    '/var/snap/lxd/common/lxd/disks/storage1.img'
    '/var/tmp/*'
    '/home/tassilo/Dropbox/semester*/**/*.mp4'
    '/home/tassilo/Videos/simon/**'
    '/home/tassilo/Videos/transcribe/**'
    '/home/tassilo/.config/google-chrome/'
    '/home/tassilo/.steam/'
)

# Borg pruning settings
KEEP_DAILY=7
KEEP_WEEKLY=4
KEEP_MONTHLY=6

# End of user-configurable constants
# ===================================

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

# some helpers and error handling:
info() { printf "\n%s %s\n\n" "$(date)" "$*" >&2; }

# Function to prevent shutdown during backup
prevent_shutdown() {
    systemctl mask systemd-poweroff.service
    systemctl mask systemd-reboot.service
    systemctl mask systemd-halt.service
    systemctl mask systemd-suspend.service
    systemctl mask systemd-hibernate.service
    systemctl mask systemd-hybrid-sleep.service
}

# Function to allow shutdown after backup
allow_shutdown() {
    systemctl unmask systemd-poweroff.service
    systemctl unmask systemd-reboot.service
    systemctl unmask systemd-halt.service
    systemctl unmask systemd-suspend.service
    systemctl unmask systemd-hibernate.service
    systemctl unmask systemd-hybrid-sleep.service
}

# Function to get the last full archive date and save to log file
update_last_archive_log() {
    local last_archive=$(borg list --last 1 --format '{time}' "$BORG_REPO")
    echo "$last_archive" > "$LAST_ARCHIVE_LOG"
    info "Last archive: $last_archive"
}

# Function to read the last archive date from log file
get_last_archive_from_log() {
    if [ -f "$LAST_ARCHIVE_LOG" ]; then
        cat "$LAST_ARCHIVE_LOG"
    else
        echo "No previous archive information available"
    fi
}

# Function to check for lock and ask user to break it using zenity
check_and_break_lock() {
    if borg list "$BORG_REPO" &>/dev/null; then
        return 0
    else
        local response
        response=$(sudo -u $GUI_USER DISPLAY=:0 zenity --entry \
            --title="Borg Backup Lock Detected" \
            --text="A lock was detected on the server.\nTo break the lock, type 'break-lock' (without quotes) and press Enter.\nTo cancel, leave blank and press Enter or close this window." \
            --width=400)

        if [ "$response" = "break-lock" ]; then
            borg break-lock "$BORG_REPO"
            return $?
        else
            return 1
        fi
    fi
}

# Function to display error message using zenity
display_error_message() {
    local message="$1"
    sudo -u $GUI_USER DISPLAY=:0 zenity --error --text="$message" --title="Backup Error" --width=300
}

# Get the last archive date from log
last_archive_info=$(get_last_archive_from_log)

# Display last archive info
sudo -u $GUI_USER DISPLAY=:0 zenity --info \
    --title="Backup Information" \
    --text="Last successful archive:\n$last_archive_info" \
    --width=300

# Use zenity for password prompt
pwd=$(sudo -u $GUI_USER DISPLAY=:0 zenity --password \
    --title="1Password Authentication")

if [ -z "$pwd" ]; then
    display_error_message "Password input cancelled. Aborting backup."
    exit 1
fi

op whoami || eval "$(echo "$pwd" | op signin)"

BORG_PASSPHRASE=$(op read "$BORG_PASSPHRASE_1PASSWORD_PATH")
export BORG_PASSPHRASE


export BORG_REPO

trap 'echo $( date ) Backup interrupted >&2; notify-send -u critical "Backup failed!" ; display_error_message "Backup was interrupted!"; allow_shutdown; exit 2' INT TERM

info "Starting backup"

# Prevent shutdown
prevent_shutdown

# Check for lock and ask user to break it if necessary
if ! check_and_break_lock; then
    info "Backup aborted due to lock"
    display_error_message "Backup aborted due to lock"
    allow_shutdown
    exit 1
fi

# Prepare exclude patterns for borg create command
exclude_options=""
for pattern in "${EXCLUDE_PATTERNS[@]}"; do
    exclude_options+="--exclude '$pattern' "
done

# Backup the most important directories into an archive named after
# the machine this script is currently running on:
eval borg create \
    --verbose \
    --filter AME \
    --list \
    --stats \
    --show-rc \
    --checkpoint-interval 1800 \
    --exclude-caches \
    "$exclude_options" \
    ::'{hostname}-{now}' \
    /etc \
    /home \
    /root \
    /var

backup_exit=$?

info "Pruning repository"

borg prune \
    --list \
    --prefix '{hostname}-' \
    --show-rc \
    --keep-daily $KEEP_DAILY \
    --keep-weekly $KEEP_WEEKLY \
    --keep-monthly $KEEP_MONTHLY

prune_exit=$?

# use highest exit code as global exit code
global_exit=$((backup_exit > prune_exit ? backup_exit : prune_exit))



if [ ${global_exit} -eq 0 ]; then
    info "Backup and Prune finished successfully"
    logger "Backup and Prune finished successfully"
    # Update the last archive log file
    update_last_archive_log
elif [ ${backup_exit} -eq 1 ]; then
    info "Backup finished with warnings"
    logger -p user.warn "Backup finished with warnings"
    display_error_message "Backup finished with warnings. Check the logs for more information."
elif [ ${prune_exit} -eq 1 ]; then
    info "Prune finished with warnings"
    logger -p user.warn "Prune finished with warnings"
    display_error_message "Prune finished with warnings. Check the logs for more information."
else
    info "Backup and/or Prune finished with errors"
    logger -p user.error "Backup and/or Prune finished with errors"
    display_error_message "Backup and/or Prune finished with errors. Check the logs for more information."
fi

# Allow shutdown after backup
allow_shutdown

info "finished backup"

exit ${global_exit}
