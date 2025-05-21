#!/usr/bin/env bash
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
DEST_DIR="/home/tassilo/Private/compressed"
PHONE_DEST_DIR="mtp://Google_Pixel_4_99041FFAZ007CF/Internal%20shared%20storage/DCIM/Camera"
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

# Function to compress video
compress_video() {
    local input_path="$1"
    local output_path="$2"
    ffmpeg -i "$input_path" -preset veryfast -vcodec libx264 -crf 23 "$output_path"
}

# Function to get all videos for today
get_todays_videos() {
    local TODAY
    TODAY=$(date +%Y%m%d)
    gio list "$SRC_DIR" | grep '\.mp4$' | grep -v '^\.trashed' | grep "PXL_${TODAY}" | sort
}

# Function to get thumbnail or metadata from MTP device
get_thumbnail_or_info() {
    local video_path="$1"
    local output_path="$2"

    # Try to get the thumbnail
    if gio info -a thumbnail::path "$video_path" 2>/dev/null | grep -q "thumbnail::path:"; then
        thumb_path=$(gio info -a thumbnail::path "$video_path" | awk '{print $3}')
        cp "$thumb_path" "$output_path"
        return 0
    fi

    # If no thumbnail, try to get basic metadata
    if gio info "$video_path" > "$output_path"; then
        return 0
    fi

    return 1
}

# Updated function to prompt for all video names
prompt_for_name() {
    local info_path="$1"
    local default_name="$2"
    local display_content

    if file "$info_path" | grep -q image; then
        # If it's an image, we'll show it in a separate window
        display "$info_path" &
        display_pid=$!
        display_content="Image preview opened in a separate window."
    else
        # If it's text info, we'll include it in the dialog
        display_content=$(head -n 5 "$info_path")
    fi

    local result
    result=$(zenity --entry \
        --title="Name Video" \
        --text="${display_content}\n\nEnter a name for this video:" \
        --entry-text="$default_name" \
        --width=400 \
        --height=250 \
        --extra-button="Skip")

    local zenity_exit_code=$?

    # If we opened an image viewer, close it now
    if [[ -n "$display_pid" ]]; then
        kill $display_pid 2>/dev/null
    fi

    # Handle the result
    case $zenity_exit_code in
        0) # User entered a name
            echo "$result"
            ;;
        1) # User clicked cancel
            return 1
            ;;
        5) # User clicked "Skip"
            echo ""
            ;;
    esac
}

# Updated function to prompt for all video names
prompt_for_all_names() {
    local videos=("$@")
    local names=()
    for video in "${videos[@]}"; do
        local base_name=$(basename "$video")
        local full_video_path="${SRC_DIR}/$(url_encode "$video")"
        local temp_info="$TEMP_DIR/${base_name%.*}.info"

        echo "Getting video info"
        if ! get_thumbnail_or_info "$full_video_path" "$temp_info"; then
            zenity --error --text="Failed to get info for $base_name."
            continue
        fi

        local default_name="${base_name%.*}"
        local new_name
        new_name=$(prompt_for_name "$temp_info" "$default_name")
        local prompt_exit_code=$?

        # Check the result
        case $prompt_exit_code in
            0) # User entered a name or clicked "Skip"
                if [[ -n "$new_name" ]]; then
                    names+=("$new_name")
                else
                    names+=("")
                fi
                ;;
            1) # User clicked cancel
                rm "$temp_info"
                return 1
                ;;
        esac

        rm "$temp_info"
    done
    echo "${names[@]}"
}

process_video() {
    local video="$1"
    local new_name="$2"
    local base_name
    base_name=$(basename "$video")
    local temp_video="$TEMP_DIR/$base_name"
    local compressed_name="${new_name}.mp4"
    local compressed_path="$TEMP_DIR/$compressed_name"

    # Compress video (using the already copied temp file)
    if compress_video "$temp_video" "$compressed_path"; then
        echo "Compressed $base_name successfully."

        # Move compressed video to local destination
        mv "$compressed_path" "$DEST_DIR/$compressed_name"

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
    # rm -f "$temp_video"
}

# Main function
main() {
    create_directories

    echo "getting todays videos"
    # Get today's videos
    readarray -t videos < <(get_todays_videos)


    echo "running through videos"

    if [ ${#videos[@]} -eq 0 ]; then
        zenity --info --text="No videos found for today."
        return
    fi

    # Prompt for all names
    IFS=$'\n' read -d '' -a names < <(prompt_for_all_names "${videos[@]}")

    echo $IFS
    # Check if user cancelled
    if [ $? -ne 0 ]; then
        echo "Operation cancelled by user."
        return
    fi
    echo "processing videos"

    # Process videos
    for i in "${!videos[@]}"; do
        if [ -n "${names[i]}" ]; then
            process_video "${videos[i]}" "${names[i]}"
        fi
    done

    # Show completion message
    zenity --info --text="Video compression and copying completed. Files saved in $DEST_DIR and $PHONE_DEST_DIR"

    # Clean up temp directory
    # rm -rf "$TEMP_DIR"
}


main
