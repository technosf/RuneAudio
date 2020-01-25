#!/bin/bash

rm $0

. /srv/http/addons-functions.sh

# all files include sub-directory
files=$( find /mnt/MPD/Webradio -type f 2> /dev/null )
if [[ -z $files ]]; then
	title -l '=' "$info No webradio files found."
	title -nt 'Copy *.pls to /mnt/MPD/Webradio/ then run again.'
	exit
fi

title -l '=' "$bar Webradio Import ..."

readarray -t files <<<"$files"
for file in "${files[@]}"; do
	filename=$( basename "$file" )
	name="${file%.*}"
	url=$( grep '^File' "$file" | cut -d '=' -f2 )
	printf "%-30s : $url\n" "$name"
	echo $name > /srv/http/data/webradios/${url//\//|}
done

title -l '=' "$bar Webradio imported successfully."
