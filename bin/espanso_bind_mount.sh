#!/bin/bash -   
#title          :espanso_bind_mount.sh
#description    :This adds a mount for the private file, since espanso doesn't recognize just symlinked files.
#author         :Tassilo Neubauer
#date           :20250205
#version        :0.1    
#usage          :./espanso_bind_mount.sh
#notes          :       
#bash_version   :5.1.16(1)-release
#============================================================================

# Paths
SOURCE_FILE="$HOME/org-roam/private.yml"
TARGET_FILE="$HOME/.config/espanso/match/private.yml"

# Function to check if the file exists and create the bind mount
setup_bind_mount() {
    if [ -f "$SOURCE_FILE" ]; then
        # Ensure the target directory exists
        mkdir -p "$(dirname "$TARGET_FILE")"

        # Check if already mounted
        if mountpoint -q "$TARGET_FILE"; then
            echo "✔ Bind mount already exists: $TARGET_FILE"
        else
            # Create bind mount
            sudo mount --bind "$SOURCE_FILE" "$TARGET_FILE"
            echo "✔ Bind mount created: $TARGET_FILE -> $SOURCE_FILE"
        fi
    else
        echo "❌ WARNING: Source file '$SOURCE_FILE' not found!"
        echo "   - Espanso will not load private matches."
        echo "   - Create the file or use a symlink instead."
    fi
}

# Function to unmount the bind mount
remove_bind_mount() {
    if mountpoint -q "$TARGET_FILE"; then
        sudo umount "$TARGET_FILE"
        echo "✔ Bind mount removed: $TARGET_FILE"
    else
        echo "❌ No bind mount found at $TARGET_FILE"
    fi
}

# Handle command-line arguments
case "$1" in
    "unmount")
        remove_bind_mount
        ;;
    *)
        setup_bind_mount
        ;;
esac
