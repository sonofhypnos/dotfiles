#!/usr/bin/env zsh
#title          :transcribe.sh
#description    :Transcribes mp4 and mp3 files.
#author         :Tassilo Neubauer
#date           :20240115
#version        :0.1    
#usage          :./transcribe.sh
#notes          :       
#bash_version   :5.1.16(1)-release
#============================================================================
set -x
# Define the path to the MeetingSummarizer directory
MEETING_SUMMARIZER_PATH="/home/tassilo/repos/MeetingSummarizer"

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

    cd "$MEETING_SUMMARIZER_PATH" || (echo "couldn't find Meeting Summarizer path edit script" && exit)
    source "$MEETING_SUMMARIZER_PATH/.venv/bin/activate"
    python cli.py summarize "$mp3_file"
}

# Main script execution

main() {
    if [[ -z "$1" ]] || [[ -z "$2" ]]; then
        echo "Usage: $0 <path-to-media-file> <path-to-log-file>"
        exit 1
    fi

    local file="$1"
    local log_file="$2"
    # Redirecting and appending both stdout and stderr to log file and displaying on console
    exec > >(tee -a "$log_file") 2>&1



    if [[ -z "$file" ]]; then
        echo "Usage: $0 <path-to-media-file>"
        exit 1
    fi
    echo "$file"

    local file_extension="${file##*.}"
    mp3_file="$file"

    # Check file extension and convert if necessary
    if [[ "$file_extension" == "mp4" ]]; then
        mp3_file=$(convert_mp4_to_mp3 "$file")
    elif [[ "$file_extension" == "mp3" ]]; then
        mp3_file="$file"
    else
        echo "Error: Unsupported file format. Please provide an .mp4 or .mp3 file."
        exit 1
    fi

    # Get the OpenAI key from 1Password
    local openai_key=$(get_openai_key)
    export OPEN_API_KEY="$openai_key"

    # Transcribe and summarize the meeting
    transcribe_and_summarize "$mp3_file"
}

main "$@"
