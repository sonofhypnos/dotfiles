#!/bin/bash -
#title          :pdfemacs.sh
#description    :open pdf in emacs and do other interesting things
#author         :Tassilo Neubauer
#date           :20220414
#version        :0.2
#usage          :./pdfemacs.sh
#notes          :
#bash_version   :5.1.4(1)-release
#============================================================================
if zenity --question --text="Do you want to open and process the PDF file?" --title="PDF Processor"; then
    zathura "$1" &
    zotero >> zotero.log &
    sleep 5
    zotadd "$1" >> zotadd.log
fi
# I am adding zathura instead of emacs here, because it is nicer to use.
#emacsclient -ce "(tassilo/open-pdf \"$1\")"
