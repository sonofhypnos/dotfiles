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

synch_org-roam.sh || logger "$0: Archiving org-roam-notes not successfull"
synch_archive () {
	logger "$0: run function synch_archive"
	archivedir="/home/tassilo/archivebox"
	cd "$archivedir" || logger -p usr.error "$0: Archiveboxes directory has changed or does not exist anymore."
	# archivebox update
	# logger "$0: updated archivebox"
	TEMP=$(mktemp -d)
	dirs=$(echo ~/.mozilla/firefox/* | grep default)
	for dir in $dirs; do
		d=$(basename $dir)
		mkdir -p "$TEMP/$d" && cp $dir/places.sqlite "$TEMP/$d/places.sqlite"
	done
	urls="home/tassilo/urls"
	touch $urls
	for dir in "$TEMP/"*;do
	    memacs_firefox -f "$dir/places.sqlite" | grep :URL: | sed -E 's/.*:URL:\s*//' >> $urls
	done
	# archivebox update | grep Adding
}

exec /home/tassilo/bin/backup_data.sh
# TODO: the rest of this will not be run because of exec
synch_archive || logger "$0: Archiving URLs not successful"

