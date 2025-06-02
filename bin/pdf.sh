#!/usr/bin/env bash
#title          :pdf.sh
#description    :open pdf in emacs and do other interesting things
#author         :Tassilo Neubauer
#date           :20220414
#version        :0.2
#usage          :./pdf.sh
#notes          :
#bash_version   :5.1.4(1)-release
#============================================================================
open_file() {
    local file="$1"
    if command -v xdg-open > /dev/null 2>&1; then
        xdg-open "$file"
    elif command -v open > /dev/null 2>&1; then
        open "$file"
    else
        return 1
    fi
}

if zenity --question --text="Add PDF to bibliography?" --title="PDF Processor"; then
    zotero &
    open_file "$1" &
    xdg-open >> zotero.log &
    sleep 5
    zotadd "$1" >> zotadd.log
else
    open_file "$1" &
fi

#NOTE: In case we ever want to use emacs for this:
#emacsclient -ce "(tassilo/open-pdf \"$1\")"
