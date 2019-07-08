#!/bin/bash

. /srv/http/addonstitle.sh

title -l '=' "$bar Restore extra directories ..."

for dir in bookmarks coverarts lyrics playlists tmp webradiopl webradios; do
	direxist=$( find /mnt/MPD/ -maxdepth 3 -type d -name $dir )
	if [[ -e "$direxist" ]]; then
		rm -r /srv/http/assets/img/$dir
		ln -s "$direxist" /srv/http/assets/img/
		echo $dir
	else
		echo -e "$info Extra directories not found."
		exit
	fi
done

title "$bar Extra directories restored successfully."
