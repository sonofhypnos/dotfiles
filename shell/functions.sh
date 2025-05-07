#!/bin/bash
# functions.sh - Shell-agnostic functions that work in both bash and zsh

# PATH management functions
path_remove() {
    PATH=$(echo -n "$PATH" | awk -v RS=: -v ORS=: "\$0 != \"$1\"" | sed 's/:$//')
}

path_append() {
    path_remove "$1"
    PATH="${PATH:+"$PATH:"}$1"
}

path_prepend() {
    path_remove "$1"
    PATH="$1${PATH:+":$PATH"}"
}

# Function to pass environment variables to sudo
sudo_exports() {
    eval sudo $(for x in $_EXPORTS; do printf '%q=%q ' "$x" "${!x}"; done) "$@"
}

# Magit in floating window for i3
magit() {
    emacsclient -c --eval '(let ((display-buffer-alist `(("^\\*magit: " display-buffer-same-window) ,display-buffer-alist))) (magit-status))' &
    sleep 0.5 && i3-msg '[title="^magit:"] move scratchpad' && i3-msg '[title="^magit:"] scratchpad show'
}

# APT history functions
apt_history() {
    case "$1" in
    install)
        cat /var/log/dpkg.log | grep 'install '
        ;;
    upgrade | remove)
        cat /var/log/dpkg.log | grep $1
        ;;
    rollback)
        cat /var/log/dpkg.log | grep upgrade |
            grep "$2" -A10000000 |
            grep "$3" -B10000000 |
            awk '{print $4"="$5}'
        ;;
    *)
        cat /var/log/dpkg.log
        ;;
    esac
}

# Calculate proportions
totals() {
    awk 'FNR==NR{s+=$1;next;} {print $1/s}' "$1" "$1"
}

# Function to get OpenAI API key from authinfo.gpg
get_openai_key() {
    # Path to your authinfo.gpg file
    local authinfo_path="${AUTHINFO_PATH:-$HOME/.authinfo.gpg}"

    # Check if the file exists
    if [ ! -f "$authinfo_path" ]; then
        echo "Error: $authinfo_path not found" >&2
        return 1
    fi

    # Extract the OpenAI API key
    local openai_key=$(gpg -q --decrypt "$authinfo_path" 2>/dev/null | grep -E "^machine api.openai.com login apikey" | head -1 | awk '{print $6}')

    # Check if we found a key
    if [ -z "$openai_key" ]; then
        echo "Error: OpenAI API key not found in $authinfo_path" >&2
        echo "Make sure you have an entry like: machine api.openai.com login apikey password YOUR_API_KEY" >&2
        return 1
    fi

    echo "$openai_key"
}

# Export OpenAI key as environment variable
use_openai_key() {
    # Get the API key
    local api_key=$(get_openai_key)

    if [ $? -ne 0 ]; then
        return 1
    fi

    # Export it as an environment variable
    export OPENAI_API_KEY="$api_key"
    echo "OpenAI API key successfully loaded from authinfo.gpg"
}

# Compress a single video
compress_video() {
    local input_path="$1"
    local output_path="$2"
    ffmpeg -i "$input_path" -preset veryfast -vcodec libx264 -crf 23 "$output_path"
}

# Batch compress all MP4 videos in a directory
batch_compress_videos() {
    local input_dir="$1"
    local output_dir="$2"

    mkdir -p "$output_dir"

    for input_file in "$input_dir"/*.mp4; do
        [ -e "$input_file" ] || continue # skip if no .mp4 files

        local filename="$(basename "$input_file" .mp4)"
        local output_file="$output_dir/${filename}_compressed.mp4"

        echo "Compressing: $input_file -> $output_file"
        compress_video "$input_file" "$output_file"
    done
}
