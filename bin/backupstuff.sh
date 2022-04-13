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

synch_archive () {
	logger "run function synch_archive"
	archivedir="$HOME/archivebox"
	cd "$archivedir" || logger -p usr.error "Archiveboxes directory has changed or does not exist anymore."
	archivebox update
	logger "updated archivebox"
	for dir in ~/.mozilla/firefox/*;do
	    memacs_firefox -f "$dir/places.sqlite" | grep :URL: | sed -E 's/.*:URL:\s*//' | xargs archivebox add
	done
	archivebox update
}

synch_org-roam.sh
sudo "$HOME/.dotfiles/bin/backup_data.sh"


logger "$0 ran successfully" & synch_archive

