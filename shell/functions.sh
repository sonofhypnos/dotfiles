path_remove() {
    PATH=$(echo -n "$PATH" | awk -v RS=: -v ORS=: "\$0 != \"$1\"" | sed 's/:$//')
}

sudo_exports(){
    eval sudo $(for x in $_EXPORTS; do printf '%q=%q ' "$x" "${!x}"; done;) "$@"
}

path_append() {
    path_remove "$1"
    PATH="${PATH:+"$PATH:"}$1"
}

path_prepend() {
    path_remove "$1"
    PATH="$1${PATH:+":$PATH"}"
}

 
magit() {
emacsclient -c --eval '(let ((display-buffer-alist `(("^\\*magit: " display-buffer-same-window) ,display-buffer-alist))) (magit-status))' & sleep 0.5 && i3-msg '[title="^magit:"] move scratchpad' && i3-msg '[title="^magit:"] scratchpad show' 
}

apt_history(){
      case "$1" in
        install)
              cat /var/log/dpkg.log | grep 'install '
              ;;
        upgrade|remove)
              cat /var/log/dpkg.log | grep $1
              ;;
        rollback)
              cat /var/log/dpkg.log | grep upgrade | \
                  grep "$2" -A10000000 | \
                  grep "$3" -B10000000 | \
                  awk '{print $4"="$5}'
              ;;
        *)
              cat /var/log/dpkg.log
              ;;
      esac
}


totals() { awk 'FNR==NR{s+=$1;next;} {print $1/s}' "$1" "$1"; }


# # Function to get OpenAI API key from 1Password
# get_openai_key() {
#     # Replace with the correct 1Password item identifier for your OpenAI key
#     local item_identifier="yocqakmciuu7bidjgftbol57wy"

#     # Fetch the OpenAI API key from 1Password
#     local openai_key=$(op item get "$item_identifier" --reveal --fields credential )

#     echo "$openai_key"
# }
# #!/bin/bash

# Function to get OpenAI API key from authinfo.gpg
get_openai_key() {
    # Path to your authinfo.gpg file (default location in ~/.authinfo.gpg)
    local authinfo_path="${AUTHINFO_PATH:-$HOME/.authinfo.gpg}"

    # Check if the file exists
    if [ ! -f "$authinfo_path" ]; then
        echo "Error: $authinfo_path not found" >&2
        return 1
    fi

    # Extract the OpenAI API key using gpg to decrypt and grep to find the entry
    # Format in authinfo.gpg is:
    # machine api.openai.com login apikey password <password-here>
    local openai_key=$(gpg -q --decrypt "$authinfo_path" 2>/dev/null | grep -E "^machine api.openai.com login apikey" | head -1 | awk '{print $6}')

    # Check if we found a key
    if [ -z "$openai_key" ]; then
        echo "Error: OpenAI API key not found in $authinfo_path" >&2
        echo "Make sure you have an entry like: machine api.openai.com login apikey password YOUR_API_KEY" >&2
        return 1
    fi

    echo "$openai_key"
}

# Example usage in your script
use_openai_key() {
    # Get the API key
    local api_key=$(get_openai_key)

    if [ $? -ne 0 ]; then
        # Error message already printed by get_openai_key
        return 1
    fi

    # Export it as an environment variable
    export OPENAI_API_KEY="$api_key"
    echo "OpenAI API key successfully loaded from authinfo.gpg"

    # Now you can run your OpenAI CLI tool
    # ./openai_cli.py
}

