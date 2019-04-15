#!/bin/bash

[[ -n "$1" ]] && scanpath=$1
[[ -n "$2" ]] && removeexist=$2

rm $0

. /srv/http/addonstitle.sh

timestart

# create temporary file to let bash run php with arguments
scandirphp=/tmp/scandir.php
cat << 'EOF' > $scandirphp
#!/usr/bin/php
<?php
require_once( '/srv/http/enhancegetcover.php' );
echo getCoverFile( $argv[ 1 ], 'scancover' );
EOF
chmod +x $scandirphp

cue=
exist=0
thumb=0
dummy=0
nonutf8=0
padW=$( tcolor '.' 7 7 )
padC=$( tcolor '.' 6 6 )
padB=$( tcolor '.' 4 4 )
padR=$( tcolor '.' 1 1 )
coverfiles='cover.jpg cover.png folder.jpg folder.png front.jpg front.png Cover.jpg Cover.png Folder.jpg Folder.png Front.jpg Front.png'

rm -f /srv/http/tmp/skipped-wav.txt # remove log

[[ -n $( ls /srv/http/assets/img/coverarts ) ]] && update=Update || update=Create
coloredname=$( tcolor 'Browse By CoverArt' )

title -l '=' "$bar $update thumbnails for $coloredname ..."

[[ -v scanpath ]] && path=$1 || path=/mnt/MPD
echo Base directory: $( tcolor "$path" )

find=$( find "$path" -mindepth 1 ! -empty ! -wholename /mnt/MPD/Webradio -type d )
if [[ -z $find ]]; then
	title "$info No directories found in $1"
	exit
fi

readarray -t dirs <<<"$find"
count=${#dirs[@]}
echo -e "\n$( tcolor $( numfmt --g $count ) ) Subdirectories"
imgcoverarts=/srv/http/assets/img/coverarts
i=0
for dir in "${dirs[@]}"; do
	created=
	(( i++ ))
	percent=$(( $i * 100 / $count ))
	echo
	mpdpath=${dir:9}
	echo ${percent}% $( tcolor "$i/$count" 8 ) $( tcolor "$mpdpath" )
	if [[ -z $( find "$dir" -maxdepth 1 -type f ) ]]; then
		echo "  No files found."
		continue
	fi
	
	# skip if non utf-8 found
	if [[ $( echo $mpdpath | grep -axv '.*' ) ]]; then
		echo "$padR Directory path contains non UTF-8 characters."
		(( nonutf8++ ))
		continue
	fi
	
	albumartist=$( mpc ls -f "%album%^^[%albumartist%|%artist%]" "$mpdpath" 2> /dev/null | head -n1 )
	# "/" not allowed in filename, "#" and "?" not allowed in img src
	thumbname=$( echo $albumartist^^$mpdpath | sed 's|/|\||g; s/#/{/g; s/?/}/g' )
	thumbfile=$imgcoverarts/$thumbname.jpg
	if [[ ! -v removeexist && -e "$thumbfile" ]]; then
		(( exist++ ))
		echo "  Skip - Thumbnail exists."
		continue
	fi
	
	for cover in $coverfiles; do
		coverfile="$dir/$cover"
		if [[ -e "$coverfile" ]]; then
			convert "$coverfile" -thumbnail 200x200 -unsharp 0x.5 "$thumbfile"
			if [[ $? == 0 ]]; then
				echo -e "$padC Thumbnail created from file."
				(( thumb++ ))
				created=1
				break
			fi
		fi
	done
	[[ $created ]] && continue
	
	coverfile=$( $scandirphp "$dir" )
	if [[ $coverfile == noaudiofile ]]; then
		echo "  No coverart or audio files found."
		continue
		
	elif [[ -n $coverfile ]]; then
		convert "$coverfile" -thumbnail 200x200 -unsharp 0x.5 "$thumbfile"
		if [[ $? == 0 ]]; then
			echo -e "$padC Thumbnail created from embedded ID3."
			(( thumb++ ))
			created=1
		fi
	fi
	[[ $created ]] && continue

	thumbfile=${thumbfile:0:-3}svg
	ln -s /srv/http/assets/img/cover.svg "$thumbfile"
	echo -e "$padB Coverart not found."
	(( dummy++ ))
done
chown -R http:http /srv/http/assets/img/coverarts

echo -e               "\n\n$padC New thumbnails     : $( tcolor $( numfmt --g $thumb ) )"
(( $dummy )) && echo -e   "$padB Dummy thumbnails   : $( tcolor $( numfmt --g $dummy ) )"
(( $nonutf8 )) && echo -e "$padR Non UTF-8 path     : $( tcolor $( numfmt --g $nonutf8 ) )"
(( $exist )) && echo -e       "Existings thumbnails : $( tcolor $( numfmt --g $exist ) )"
[[ -v scanpath ]] && echo -e  "Parsed directory     : $( tcolor "$scanpath" )"

curl -s -v -X POST 'http://localhost/pub?id=notify' \
	-d '{ "title": "'"Browse By CoverArt"'", "text": "'"Thumbnails ${update}d."'" }' \
	&> /dev/null

timestop

title -l '=' "$bar Thumbnails for $coloredname ${update}d successfully."

echo
echo Thumbnails directory : $( tcolor "$imgcoverarts" )
echo
echo -e "$bar To change individually:"
echo "    - CoverArt > long-press thumbnail > CoverArt icon"
echo -e "$bar To update with database:"
echo "    - Full    - Library > long-press CoverArt"
echo "    - Partial - Library > directory > context menu > Update thumbnails"
echo "    - CoverArt > long-press old thumbnail > Delete icon"
