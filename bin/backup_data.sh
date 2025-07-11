#!/usr/bin/env bash
#title          :backup_data.sh
#description    :Backup data from laptop to pc
#author         :Tassilo Neubauer
#date           :2024-08-20
#version        :1.0
#usage          :./backup_data.sh
#notes          : Launching the user gui things from root is fundamentally brittle. For this reason, we are minimizing the gui stuff as much as possible.
#We could also consider separating into a user and a root backup, where the root
#one happens less frequently, but the only advantage would be less annoyance
#with the root one, and if they are out of sync this could complicate things if
#we restore things. We could also consider trying to eliminate truly all zenity gui things (like asking for break-lock).
#We could also decide there is no user interaction and we have another user script that reads log files from this script and lets the user know if we should do things like break-lock.
#For the above reasons we decided to save the password for the borg backup under root privileges. We will put into the documentation that we need to restore this.
# TODO: create another small test backup repository?
#bash_version   :5.1.4(1)-release
#============================================================================

# User-configurable constants
# ============================
# Modify these variables to customize the script for your setup

# The user who will receive GUI prompts
GUI_USER="tassilo"

# The repository URL for your Borg backup
BORG_REPO="borgbase:./repo"



LAST_ARCHIVE_LOG="$HOME/.local/share/borg_last_archive.log"
BORG_LOG_FILE="$HOME/.local/share/borg_backup.log"

# The 1Password item path for the Borg passphrase (Or adjust code below whichever way you handle secrets.)
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
    '/home/tassilo/Dropbox/semester*/**/*.mp4'
    '/home/tassilo/Videos/simon/**'
    '/home/tassilo/Videos/transcribe/**'
    '/home/tassilo/.config/google-chrome/'
    '/home/tassilo/.config/RescueTime.com/log/debug_log.txt'
    '/home/tassilo/.steam/'
    '/home/tassilo/.dropbox/'
    '/home/tassilo/.mozilla/'
    '/home/tassilo/.vscode/'
)

TEMP_LOG_DIR="$HOME/.cache/borg_backup_logs"

FIREFOX_PROFILE_DIR="/home/tassilo/.mozilla/" # NOTE: Manually also added to ignore directories
TEMP_FIREFOX_DIR="$TEMP_LOG_DIR/firefox_backup"

# Borg pruning settings
KEEP_DAILY=7
KEEP_WEEKLY=4
KEEP_MONTHLY=6

# End of user-configurable constants
# ===================================

# Function to pause Firefox
pause_firefox() {
    pgrep firefox | xargs -r -n1 kill -STOP
}

# Function to resume Firefox
resume_firefox() {
    pgrep firefox | xargs -r -n1 kill -CONT
}


# Function to copy Firefox files
copy_firefox_files() {
    local profile_dir
    profile_dir=$FIREFOX_PROFILE_DIR
    if [ -n "$profile_dir" ]; then
        mkdir -p "$TEMP_FIREFOX_DIR"
        cp -a "$profile_dir"/* "$TEMP_FIREFOX_DIR/"
    else
        info "Firefox profile directory not found"
    fi
}

# Function to clean up temporary log files
cleanup_temp_logs() {
    rm -rf "$TEMP_LOG_DIR"
}

if [ "$EUID" -e 0 ]; then
    echo "Please run as user"
    exit 1
fi

# some helpers and error handling:
info() {
    local log_message
    log_message="$(date) $*"
    echo "$log_message" | tee -a "$BORG_LOG_FILE" >&2
    echo "" | tee -a "$BORG_LOG_FILE" >&2
}

update_last_archive_log() {
    local last_archive=$(borg list --last 1 --format '{time}' "$BORG_REPO")
    if [ -n "$last_archive" ]; then
        echo "$last_archive" >"$LAST_ARCHIVE_LOG"
        info "Last archive updated: $last_archive"
    else
        info "Failed to retrieve last archive information"
    fi
}

# Function to read the last archive date from log file
get_last_archive_from_log() {
    if [ -f "$LAST_ARCHIVE_LOG" ]; then
        cat "$LAST_ARCHIVE_LOG"
    else
        echo "No previous archive information available"
    fi
}

# Functions involving user-interaction with zenity:
check_and_break_lock() {
    if borg list "$BORG_REPO" &>/dev/null; then
        return 0
    else
        local response
        response=$(zenity --entry \
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

display_error_message() {
    local message="$1"
    zenity --error --text="$message" --title="Backup Error" --width=300
}

display_info_message() {
    local message="$1"
    zenity --info --text="$message" --title="Backup Information" --width=300
}

# --- URL History Archiving --- #
info "Running browser history backup (Firefox + Chrome)..."
/home/tassilo/.dotfiles/bin/backup-urls.sh || info "Error: backup-urls.sh failed!"

# Get the last archive date from log
last_archive_info=$(get_last_archive_from_log)

display_info_message "Last successful archive:\n$last_archive_info"

# FIXME: we need to fetch the password differently now that the script is run by the user, it will only work if BORG_PASSPHRASE is already defined
# BORG_PASSPHRASE=$(cat /root/.borg_passphrase)
# export BORG_PASSPHRASE

if [ -z "$BORG_PASSPHRASE" ]; then
    display_info_message "Password not found. Aborting backup"
    info "Password not found. Aborting backup"
    logger "Password not found. Aborting backup"
    exit 0
fi

export BORG_REPO

trap 'echo $( date ) Backup interrupted >&2; notify-send -u critical "Backup failed!" ; display_error_message "Backup was interrupted!"; exit 2' INT TERM

info "Starting backup"

## Check for lock and ask user to break it if necessary
if ! check_and_break_lock; then
    info "Backup aborted due to lock"
    display_error_message "Backup aborted due to lock"
    exit 1
fi

# Prepare exclude patterns for borg create command
exclude_options=""
for pattern in "${EXCLUDE_PATTERNS[@]}"; do
    exclude_options+="--exclude '$pattern' "
done

# Copy log files to temporary directory
copy_log_files

# Handle Firefox files
info "Pausing Firefox for file copy"
pause_firefox
copy_firefox_files
resume_firefox
info "Firefox resumed"

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
    /home \
    "$TEMP_LOG_DIR"

backup_exit=$?

info "Pruning repository"

borg prune \
    --list \
    --glob-archives '{hostname}-' \
    --show-rc \
    --keep-daily $KEEP_DAILY \
    --keep-weekly $KEEP_WEEKLY \
    --keep-monthly $KEEP_MONTHLY

prune_exit=$?

# use highest exit code as global exit code
global_exit=$((backup_exit > prune_exit ? backup_exit : prune_exit))

# Function to handle exit codes and return a status message
handle_exit_code() {
    local exit_code=$1
    local operation=$2

    case $exit_code in
    0)
        echo "$operation completed successfully"
        return 0
        ;;
    1)
        echo "$operation completed with warnings"
        return 1
        ;;
    *)
        echo "$operation failed with critical errors"
        return 2
        ;;
    esac
}

# Handle backup and prune exit codes
backup_status=$(handle_exit_code $backup_exit "Backup")
backup_code=$?

prune_status=$(handle_exit_code $prune_exit "Prune")
prune_code=$?

# Log the status of each operation
info "$backup_status"
info "$prune_status"

# Determine overall exit status
if [ $backup_code -eq 2 ] || [ $prune_code -eq 2 ]; then
    info "Backup and/or Prune finished with critical errors"
    logger -p user.error "Backup and/or Prune finished with critical errors"
    display_error_message "Backup and/or Prune finished with critical errors. Check the logs for more information."
    global_exit=2
elif [ $backup_code -eq 1 ] || [ $prune_code -eq 1 ]; then
    info "Backup and/or Prune finished with warnings"
    logger -p user.warn "Backup and/or Prune finished with warnings"
    display_error_message "Backup and/or Prune finished with warnings. Check the logs for more information."
    global_exit=1
else
    display_info_message "Backup and Prune finished successfully"
    info "Backup and Prune finished successfully"
    logger "Backup and Prune finished successfully"
    global_exit=0
fi

# Update the last archive log file if there are no critical errors
if [ $backup_code -ne 2 ]; then
    update_last_archive_log
fi

info "finished backup"

exit ${global_exit}
