#!/bin/bash

rm $0

. /srv/http/bash/addons-functions.sh

# all files include sub-directory
files=$( find /var/lib/mpd/playlists -type f 2> /dev/null )
if [[ -z $files ]]; then
	title -l '=' "$info No playlists found."
	title -nt 'Copy *.m3u to /var/lib/mpd/playlists then run again.'
	exit
fi

title -l '=' "$bar Playlist Import ..."

mpc -q clear

readarray -t files <<<"$files"
for file in "${files[@]}"; do
	name=$( basename "$file" .m3u )
	if [[ -e "/srv/http/data/playlists/$name" ]]; then
		echo -e "$info Skip: $name exists"
		continue
	fi
	
	echo $name
	cat "$file" | mpc add
	php /srv/http/mpdplaylist.php save "$name"
done

title -l '=' "$bar Playlists imported successfully."
title -nt "Files in /var/lib/mpd/playlists can be deleted."
