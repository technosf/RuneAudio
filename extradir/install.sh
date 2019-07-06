#!/bin/bash

. /srv/http/addonstitle.sh

title -l '=' "$bar Restore extra directories ..."

makeLink() {
	direxist=$( find /mnt/MPD/ -maxdepth 3 -type d -name $1 )
	if [[ -e "$direxist" ]]; then
		rm -r /srv/http/assets/img/$1
		ln -s "$direxist" /srv/http/assets/img/
		echo $dir
	else
		echo -e "$warn $1 not found."
	fi
}

for dir in bookmarks coverarts lyrics playlists tmp webradiopl webradios; do
	makeLink $dir
done

title "$bar Extra directories restored successfully."
