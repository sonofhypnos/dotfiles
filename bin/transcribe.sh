#!/bin/bash -   
#title          :transcribe.sh
#description    :Transcribes mp4 and mp3 files.
#author         :Tassilo Neubauer
#date           :20240115
#version        :0.1    
#usage          :./transcribe.sh
#notes          :       
#bash_version   :5.1.16(1)-release
#============================================================================

#!/bin/bash

# Define the path to the MeetingSummarizer directory
MEETING_SUMMARIZER_PATH="$HOME/repos/MeetingSummarizer"

# Function to convert MP4 to MP3 using FFmpeg
convert_mp4_to_mp3() {
    local mp4_file="$1"
    local mp3_file="${mp4_file%.mp4}.mp3"

    ffmpeg -i "$mp4_file" -vn \
           -acodec libmp3lame -ac 2 -ab 160k -ar 48000 \
           "$mp3_file"

    echo "$mp3_file"
}

# Function to get OpenAI API key from 1Password
get_openai_key() {
    # Replace with the correct 1Password item identifier for your OpenAI key
    local item_identifier="yocqakmciuu7bidjgftbol57wy"

    # Fetch the OpenAI API key from 1Password
    local openai_key=$(op item get "$item_identifier" --fields credential)

    echo "$openai_key"
}

# Function to transcribe and summarize a meeting
transcribe_and_summarize() {
    local mp3_file="$1"

    cd "$MEETING_SUMMARIZER_PATH"
    python cli.py summarize "$mp3_file"
}

# Main script execution
main() {
    local mp4_file="$1"

    if [ -z "$mp4_file" ]; then
        echo "Usage: $0 <path-to-mp4-file>"
        exit 1
    fi

    # Convert MP4 to MP3
    local mp3_file=$(convert_mp4_to_mp3 "$mp4_file")

    # Get the OpenAI key from 1Password
    local openai_key=$(get_openai_key)
    export OPENAI_API_KEY="$openai_key"

    # Transcribe and summarize the meeting
    transcribe_and_summarize "$mp3_file"
}

main "$@"
