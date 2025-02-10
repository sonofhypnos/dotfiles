#!/bin/bash -
#title          :pdf.sh
#description    :open pdf in emacs and do other interesting things
#author         :Tassilo Neubauer
#date           :20220414
#version        :0.2
#usage          :./pdf.sh
#notes          :
#bash_version   :5.1.4(1)-release
#============================================================================
if zenity --question --text="Add PDF to bibliography?" --title="PDF Processor"; then
    zotero &
    # FIXME: doesn't work if zotero is not active. (We should use something better than the hack above)
    zathura "$1" &
    zotero >> zotero.log &
    sleep 5
    zotadd "$1" >> zotadd.log
else
    zathura "$1" &
fi
# I am adding zathura instead of emacs here, because it is nicer to use.
#emacsclient -ce "(tassilo/open-pdf \"$1\")"
