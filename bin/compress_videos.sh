#!/bin/zsh -
#title          :compress_videos.sh
#description    :Compress videos from phone and move them back to phone
#author         :Tassilo Neubauer
#date           :20240822
#version        :0.1    
#usage          :./compress_videos.sh
#notes          :       
#bash_version   :5.1.16(1)-release
#============================================================================

#!/bin/zsh

# Set the source directory for the MTP-connected phone
SRC_DIR="mtp://Google_Pixel_4_99041FFAZ007CF/Internal%20shared%20storage/DCIM/Camera"

# Set the destination directory on the computer
DEST_DIR="$HOME/Private/compressed"

# Set the destination directory on the phone for compressed videos
PHONE_DEST_DIR="mtp://Google_Pixel_4_99041FFAZ007CF/Internal%20shared%20storage/DCIM/Camera"

# Create the destination directory on the computer if it doesn't exist
mkdir -p "$DEST_DIR"

# Create the destination directory on the phone
gio mkdir "$PHONE_DEST_DIR"

# Get today's date in the format YYYYMMDD
TODAY=$(date +%Y%m%d)

# Prompt for a name using zenity
NAME=$(zenity --entry --title="Video Compression" --text="Enter a name for this batch of videos:")

# Check if user canceled the prompt
if [[ $? -ne 0 ]]; then
    zenity --error --text="Operation canceled by user."
    exit 1
fi

# Function to URL encode a string
url_encode() {
    printf '%s' "$1" | jq -sRr @uri
}

# Find MP4 files created today
gio list "$SRC_DIR" | grep '\.mp4$' | while read -r video; do
    # Extract date from filename (assuming format VID_YYYYMMDD_*)
    video_date=$(echo "$video" | grep -oP 'VID_\K\d{8}')

    # Check if video was created today
    if [[ "$video_date" == "$TODAY" ]]; then
        # Get the full path of the video
        full_video_path="${SRC_DIR}/$(url_encode "$video")"

        # Get the base name of the video
        base_name=$(basename "$video")
        compressed_name="${NAME}_${base_name}"

        # Copy the video to a temporary location
        temp_video="/tmp/$base_name"
        if gio copy "$full_video_path" "$temp_video"; then
            # Compress the video and move it to the destination on the computer
            if ffmpeg -i "$temp_video" -vcodec libx264 -crf 23 "$DEST_DIR/$compressed_name"; then
                echo "Compressed $base_name successfully."

                # Copy the compressed video back to the phone
                if gio copy "$DEST_DIR/$compressed_name" "$PHONE_DEST_DIR/"; then
                    echo "Copied compressed $compressed_name back to the phone."
                else
                    zenity --error --text="Failed to copy $compressed_name back to the phone."
                fi
            else
                zenity --error --text="Failed to compress $base_name"
            fi

            # Remove the temporary file
            rm "$temp_video"
        else
            zenity --error --text="Failed to copy $base_name from the phone."
        fi
    fi
done

# Show a completion message
zenity --info --text="Video compression and copying completed. Files saved in $DEST_DIR and $PHONE_DEST_DIR"
