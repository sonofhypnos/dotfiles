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


# Function to get OpenAI API key from 1Password
get_openai_key() {
    # Replace with the correct 1Password item identifier for your OpenAI key
    local item_identifier="yocqakmciuu7bidjgftbol57wy"

    # Fetch the OpenAI API key from 1Password
    local openai_key=$(op item get "$item_identifier" --reveal --fields credential )

    echo "$openai_key"
}
