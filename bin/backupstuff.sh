#!/bin/bash -   
#title          :backupstuff.sh
#description    :Backup my online data and subsequently update computer. Adds new urls to archivebox, update the index and do backup with borg.
#author         :Tassilo Neubauer
#date           :20220102
#version        :0.1    
#usage          :./update_archivebox.sh
#notes          :       
#bash_version   :5.1.4(1)-release
#============================================================================

archivedir="$HOME/archivebox"
cd "$archivedir" || echo "Archiveboxes directory has changed or does not exist anymore."
for dir in ~/.mozilla/firefox/*;do
    memacs_firefox -f "$dir/places.sqlite" | grep :URL: | sed -E 's/.*:URL:\s*//' | xargs archivebox add
done
