#!/bin/bash -
#title          :compress_videos.sh
#description    :Compress videos from phone and move them back to phone
#author         :Tassilo Neubauer
#date           :20240822
#version        :0.1    
#usage          :./compress_videos.sh
#notes          :       
#bash_version   :5.1.16(1)-release
#============================================================================

# Configuration
SRC_DIR="mtp://Google_Pixel_4_99041FFAZ007CF/Internal%20shared%20storage/DCIM/Camera"
DEST_DIR="$HOME/Private/compressed"
PHONE_DEST_DIR="mtp://Google_Pixel_4_99041FFAZ007CF/Internal%20shared%20storage/DCIM/CompressedVideos"
TEMP_DIR="/tmp/video_compression"

# Function to URL encode a string
url_encode() {
    printf '%s' "$1" | jq -sRr @uri
}

# Function to create necessary directories
create_directories() {
    mkdir -p "$DEST_DIR"
    #gio mkdir "$PHONE_DEST_DIR"
    mkdir -p "$TEMP_DIR"
}

# Function to extract thumbnail
extract_thumbnail() {
    local video_path="$1"
    local thumb_path="$2"
    ffmpeg -i "$video_path" -vframes 1 -q:v 2 "$thumb_path" -y
}

# Function to prompt for video name with thumbnail
prompt_for_name() {
    local thumb_path="$1"
    local default_name="$2"
    zenity --entry \
        --title="Name Video" \
        --text="Enter a name for this video:" \
        --entry-text="$default_name" \
        --width=400 \
        --height=250 \
        --extra-button="Skip" \
        --filename="$thumb_path"
}

# Function to compress video
compress_video() {
    local input_path="$1"
    local output_path="$2"
    ffmpeg -i "$input_path" -preset veryfast -vcodec libx264 -crf 23 "$output_path"
}

# Function to get all videos for today
get_todays_videos() {
    local TODAY=$(date +%Y%m%d)
    gio list "$SRC_DIR" | grep '\.mp4$' | grep -v '^\.trashed' | grep "PXL_${TODAY}" | sort
}

# Function to prompt for all video names
prompt_for_all_names() {
    local videos=("$@")
    local names=()
    for video in "${videos[@]}"; do
        local base_name=$(basename "$video")
        local temp_video="$TEMP_DIR/$base_name"
        local temp_thumb="$TEMP_DIR/${base_name%.*}.png"

        # Copy video to temporary location
        if ! gio copy "${SRC_DIR}/$(url_encode "$video")" "$temp_video"; then
            zenity --error --text="Failed to copy $base_name from the phone."
            continue
        fi

        # Extract thumbnail
        if ! extract_thumbnail "$temp_video" "$temp_thumb"; then
            zenity --error --text="Failed to extract thumbnail for $base_name."
            rm "$temp_video"
            continue
        fi

        # Prompt for name with thumbnail
        local default_name="${base_name%.*}"
        local new_name=$(prompt_for_name "$temp_thumb" "$default_name")

        # Check the result of zenity
        case $? in
            0) # User entered a name
                [[ -z "$new_name" ]] && new_name="$default_name"
                names+=("$new_name")
                ;;
            1) # User clicked cancel
                rm "$temp_video" "$temp_thumb"
                return 1
                ;;
            2) # User clicked "Skip"
                names+=("")
                ;;
        esac

        rm "$temp_video" "$temp_thumb"
    done
    echo "${names[@]}"
}

# Main function
main() {
    create_directories

    # Get today's videos
    readarray -t videos < <(get_todays_videos)

    if [ ${#videos[@]} -eq 0 ]; then
        zenity --info --text="No videos found for today."
        return
    fi

    # Prompt for all names
    IFS=$'\n' read -d '' -a names < <(prompt_for_all_names "${videos[@]}")

    # Check if user cancelled
    if [ $? -ne 0 ]; then
        echo "Operation cancelled by user."
        return
    fi

    # Process videos
    for i in "${!videos[@]}"; do
        if [ -n "${names[i]}" ]; then
            process_video "${videos[i]}" "${names[i]}"
        fi
    done

    # Show completion message
    zenity --info --text="Video compression and copying completed. Files saved in $DEST_DIR and $PHONE_DEST_DIR"

    # Clean up temp directory
    rm -rf "$TEMP_DIR"
}

# Function to process a single video (updated)
process_video() {
    local video="$1"
    local new_name="$2"
    local base_name=$(basename "$video")
    local full_video_path="${SRC_DIR}/$(url_encode "$video")"
    local temp_video="$TEMP_DIR/$base_name"
    local compressed_name="${new_name}.mp4"

    # Copy video to temporary location
    if ! gio copy "$full_video_path" "$temp_video"; then
        zenity --error --text="Failed to copy $base_name from the phone."
        return
    fi

    # Compress video
    if compress_video "$temp_video" "$DEST_DIR/$compressed_name"; then
        echo "Compressed $base_name successfully."

        # Copy compressed video back to phone
        if gio copy "$DEST_DIR/$compressed_name" "$PHONE_DEST_DIR/"; then
            echo "Copied compressed $compressed_name back to the phone."
        else
            zenity --error --text="Failed to copy $compressed_name back to the phone."
        fi
    else
        zenity --error --text="Failed to compress $base_name"
    fi

    # Clean up
    rm "$temp_video"
}
main
