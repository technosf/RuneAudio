#!/bin/bash

[[ -n "$1" ]] && scanpath=$1
[[ -n "$2" ]] && removeexist=$2

#rm $0

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
imgcoverarts=/srv/http/assets/img/coverarts

function createThumbnail() {
	percent=$(( $i * 100 / $count ))
	echo
	echo ${percent}% $( tcolor "$i/$count$cue" 8 ) $( tcolor "$album" ) • $artist
	
	# skip if non utf-8 found
	if [[ $( echo $thumbname | grep -axv '.*' ) ]]; then
		echo "$padR Name contains non UTF-8 characters."
		(( nonutf8++ ))
		return
	fi
	
	# "/" not allowed in filename, "#" and "?" not allowed in img src
	thumbname=$( echo $thumbname | sed 's|/|\||g; s/#/{/g; s/?/}/g' )
	thumbfile="$imgcoverarts/$thumbname.jpg"
	dummyfile="$imgcoverarts/$thumbname.svg"
	rm -f "$dummyfile"
	
	if [[ ! -v removeexist && -e "$thumbfile" ]]; then
		(( exist++ ))
		echo "  Skip - Thumbnail exists."
		return
	fi
	
	for cover in $coverfiles; do
		coverfile="$dir/$cover"
		if [[ -e "$coverfile" ]]; then
			convert "$coverfile" \
				-thumbnail 200x200 \
				-unsharp 0x.5 \
				"$thumbfile"
			if [[ $? == 0 ]]; then
				echo -e "$padC Thumbnail created - file: $coverfile"
				(( thumb++ ))
				return
			fi
		fi
	done
	
	if [[ !$cue ]]; then
		coverfile=$( $scandirphp "$dir" )
		if [[ $coverfile != 'noaudiofile' ]]; then
			convert "$coverfile" -thumbnail 200x200 -unsharp 0x.5 "$thumbfile"
			if [[ $? == 0 ]]; then
				rm "$coverfile"
				echo -e "$padC Thumbnail created - ID3: $file"
				(( thumb++ ))
				return
			fi
			rm -f "$coverfile"
		fi
	fi
	
	ln -s /srv/http/assets/img/cover.svg "$dummyfile"
	echo -e "$padB Coverart not found."
	(( dummy++ ))
}

[[ -n $( ls /srv/http/assets/img/coverarts ) ]] && update=Update || update=Create
coloredname=$( tcolor 'Browse By CoverArt' )

title -l '=' "$bar $update thumbnails for $coloredname ..."

title "$bar Get directory list ..."

if [[ -v scanpath ]]; then
	path=$1
	find=$( find "$1" -type d )
else
	path=/mnt/MPD
	find=$( find "$path" -mindepth 1 ! -empty ! -wholename /mnt/MPD/Webradio -type d )
fi
if [[ -z $find ]]; then
	title "$info No music files found in $1"
	exit
fi
readarray -t dirs <<<"$find"
count=${#dirs[@]}
echo -e "\n$( tcolor $( numfmt --g $count ) ) Directories"

i=0
albumArtist=
for dir in "${dirs[@]}"; do
	path=${dir/\/mnt\/MPD\/}
	mpcls=$( mpc ls -f "[%album%^[%albumartist%|%artist%]]" "$path" | awk '!a[$0]++ && NF' )
	(( i++ ))
	percent=$(( $i * 100 / $count ))
	echo ${percent}% $( tcolor "$i/$count dir" 8 ) $path
	[[ -z $mpcls ]] && continue
	albumArtist="$albumArtist"$'\n'"$mpcls^$dir"
done
albumArtist=$( echo "$albumArtist" | awk '!a[$0]++' )
readarray -t albumArtists <<<"${albumArtist:1}" # remove 1st \n
count=${#albumArtists[@]}
echo "count = $count"
i=0
for albumArtist in "${albumArtists[@]}"; do
	album=$( echo "$albumArtist" | cut -d'^' -f1 )
	artist=$( echo "$albumArtist" | cut -d'^' -f2 )
	dir=$( echo "$albumArtist" | cut -d'^' -f3 )
	thumbname="$album^^$artist"
	(( i++ ))
	createThumbnail
done
# cue - not in mpd database
[[ $1 ]] && path=$1 || path=/mnt/MPD
cueFiles=$( find "$path" -type f -name '*.cue' )
if [[ -n $cueFiles ]]; then
	readarray -t files <<<"$cueFiles"
	count=${#files[@]}
	title "$bar Cue Sheet - Get album list ..."

	cue=' cue'
	i=0
	for file in "${files[@]}"; do
		tag=$( cat "$file" | grep '^TITLE\|^PERFORMER' )
		album=$( echo "$tag" | grep TITLE | sed 's/.*"\(.*\)".*/\1/' )
		artist=$( echo "$tag" | grep PERFORMER | sed 's/.*"\(.*\)".*/\1/' )
		dir=$( dirname "$file" )
		thumbname="$album^^$artist^^${dir/\/mnt\/MPD\/}"
		(( i++ ))
		createThumbnail
	done
fi

chown -h http:http /srv/http/assets/img/coverarts/*

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
echo "    - CoverArt > long-press thumbnail > CoverArt / Delete"
echo -e "$bar To update with updated database:"
echo "    - Library > directory > context menu > Update thumbnails"
