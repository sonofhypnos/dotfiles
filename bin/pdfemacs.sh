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

zotadd "$1"
emacsclient -ce "(tassilo/open-pdf \"$1\")"
