#!/bin/bash

path=$1
[[ $2 != 0 ]] && removeexist=1

rm $0

. /srv/http/addonstitle.sh

[[ $3 != 0 ]] && mpc update

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

function createThumbnail() {
	mpdpath=${dir:9}
	echo
	echo ${percent}% $( tcolor "$i/$count" 8 ) $( tcolor "$mpdpath" )
	if [[ -z $( find "$dir" -maxdepth 1 -type f ) ]]; then
		echo "  No files found."
		return
	fi
	
	# skip if non utf-8 found
	if [[ $( echo $mpdpath | grep -axv '.*' ) ]]; then
		echo "$padR Directory path contains non UTF-8 characters."
		(( nonutf8++ ))
		return
	fi
	
	cuefile=$( find "$path" -maxdepth 1 -type f -name '*.cue' | head -1 )
	if [[ -z $cuefile ]]; then
		thumbname=$( mpc ls -f "[%album%^^[%albumartist%|%artist%]]" "$mpdpath" 2> /dev/null | awk '!a[$0]++ && NF' | head -1 )
	else
		tag=$( cat "$cuefile" | grep '^TITLE\|^PERFORMER' )
		album=$( echo "$tag" | grep TITLE | sed 's/.*"\(.*\)".*/\1/' )
		artist=$( echo "$tag" | grep PERFORMER | sed 's/.*"\(.*\)".*/\1/' )
		thumbname="$album^^$artist^^${dir/\/mnt\/MPD\/}"
	fi
	# "/" not allowed in filename, "#" and "?" not allowed in img src
	thumbname=$( echo $thumbname | sed 's|/|\||g; s/#/{/g; s/?/}/g' )
	thumbfile=$imgcoverarts/$thumbname.jpg
	if (( ${#thumbfile} > 255 )); then
		echo "$padR Skip - $( tcolor "$thumbfile" 1 ) longer than 255 characters."
		return
	fi
	
	if [[ -e "$thumbfile" && ! $removeexist ]]; then
		echo "$padW Skip - Thumbnail exists."
		(( exist++ ))
		return
	fi
	
	dummyfile=${thumbfile:0:-3}svg
	rm -f "$dummyfile"
	for cover in $coverfiles; do
		coverfile="$dir/$cover"
		if [[ -e "$coverfile" ]]; then
			convert "$coverfile" -thumbnail 200x200 -unsharp 0x.5 "$thumbfile"
			if [[ $? == 0 ]]; then
				if [[ $removeexist ]]; then
					echo "$padB Replace - Existing thumbnail."
					(( replace++ ))
				else
					echo -e "$padC Thumbnail created from file: $cover"
					(( thumb++ ))
				fi
				return
			fi
		fi
	done
	
	if [[ -z $cuefile ]]; then
		coverfile=$( $scandirphp "$dir" )
		if [[ $coverfile != wavefile ]]; then
			if [[ $coverfile == noaudiofile ]]; then
				echo "  No coverart or audio files found."
				return
				
			elif [[ -n $coverfile ]]; then
				convert "$coverfile" -thumbnail 200x200 -unsharp 0x.5 "$thumbfile"
				if [[ $? == 0 ]]; then
					if [[ $removeexist ]]; then
						echo "$padB Replace - Existing thumbnail."
						(( replace++ ))
					else
						echo -e "$padC Thumbnail created from embedded ID3."
						(( thumb++ ))
					fi
					return
				fi
			fi
		fi
	fi

	ln -s /srv/http/assets/img/cover.svg "$dummyfile"
	echo -e "$padW Dummy - Coverart not found."
	(( dummy++ ))
}

cue=
replace=0
exist=0
thumb=0
dummy=0
nonutf8=0
padW=$( tcolor '.' 7 7 )
padC=$( tcolor '.' 6 6 )
padB=$( tcolor '.' 4 4 )
padR=$( tcolor '.' 1 1 )
imgcoverarts=/srv/http/assets/img/coverarts
coverfiles='cover.jpg cover.png folder.jpg folder.png front.jpg front.png Cover.jpg Cover.png Folder.jpg Folder.png Front.jpg Front.png'

[[ -n $( ls $imgcoverarts ) ]] && update=Update || update=Create
coloredname=$( tcolor 'Browse By CoverArt' )

title -l '=' "$bar $update thumbnails for $coloredname ..."

echo Base directory: $( tcolor "$path" )
find=$( find "$path" -mindepth 1 ! -empty ! -wholename /mnt/MPD/Webradio -type d | sort )
[[ -z $find ]] && find=$path
readarray -t dirs <<<"$find"
count=${#dirs[@]}
echo -e "\n$( tcolor $( numfmt --g $count ) ) Subdirectories"
i=0
for dir in "${dirs[@]}"; do
	(( i++ ))
	percent=$(( $i * 100 / $count ))
	createThumbnail
done
chown -h http:http $imgcoverarts/*

echo -e               "\n\n$padC New thumbnails       : $( tcolor $( numfmt --g $thumb ) )"
(( $replace )) && echo -e "$padB Replaced thumbnails  : $( tcolor $( numfmt --g $replace ) )"
(( $exist )) && echo -e   "$padW Existings thumbnails : $( tcolor $( numfmt --g $exist ) )"
(( $dummy )) && echo -e   "$padW Dummy thumbnails     : $( tcolor $( numfmt --g $dummy ) )"
(( $nonutf8 )) && echo -e "$padR Non UTF-8 path       : $( tcolor $( numfmt --g $(nonutf8) ) )"
echo
echo -e                       "      Total thumbnails : $( tcolor $( numfmt --g $( ls -1 $imgcoverarts | wc -l ) ) )"
echo -e  "      Parsed directory : $( tcolor "$path" )"

curl -s -v -X POST 'http://localhost/pub?id=notify' \
	-d '{ "title": "'"Browse By CoverArt"'", "text": "'"Thumbnails ${update}d."'" }' \
	&> /dev/null

timestop

title -l '=' "$bar Thumbnails for $coloredname ${update}d successfully."

echo
echo Thumbnails directory : $( tcolor "$imgcoverarts" )
echo
echo -e "$bar To change individually:"
echo "    - CoverArt > long-press thumbnail > coverArt / delete"
echo -e "$bar To update with updated database:"
echo "    - Library > directory > context menu > Update thumbnails"
