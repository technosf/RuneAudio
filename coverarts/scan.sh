#!/bin/bash

path=$1
[[ $2 == 1 ]] && removeexist=1

rm $0

. /srv/http/addonstitle.sh

[[ $3 == 1 ]] && mpc update

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

createThumbnail() {
	mpdpath=${dir:9}
	echo
	echo ${percent}% $( tcolor "$i/$count" 8 ) $( tcolor "$mpdpath" )
	# skip if non utf-8 name
	if [[ $( echo $mpdpath | grep -axv '.*' ) ]]; then
		(( nonutf8++ ))
		echo -e "$padR Skip - $mpdpath ) contains non UTF-8 characters."
		echo $mpdpath >> $nonutf8log
		return
	fi
	
	cuefile=$( find "$dir" -maxdepth 1 -type f -name '*.cue' | head -1 )
	if [[ -z $cuefile ]]; then
		thumbname=$( mpc ls -f "[%album%^^[%albumartist%|%artist%]]" "$mpdpath" 2> /dev/null | awk '/\^\^/ && !a[$0]++ && NF' | head -1 )
		if [[ -z $thumbname ]]; then
			echo "  No files in MPD database."
			return
		fi
		albumartist=$( echo $thumbname | tr -s ^^ )
		album=$( echo $albumartist | cut -d^ -f1 )
		artist=$( echo $albumartist | cut -d^ -f2 )
	else
		album=$( cat "$cuefile" | grep '^TITLE' | cut -d'"' -f2 )
		artist=$( cat "$cuefile" | grep '^PERFORMER' | cut -d'"' -f2 )
		thumbname="$album^^$artist^^${dir/\/mnt\/MPD\/}"
	fi
	# "/" not allowed in filename, "#" and "?" not allowed in img src
	thumbname=$( echo $thumbname | sed 's|/|\||g; s/#/{/g; s/?/}/g' )
	thumbfile=$imgcoverarts/$thumbname.jpg
	if (( ${#thumbfile} > 255 )); then
		(( longname++ ))
		echo -e "$padR Skip - $thumbfile longer than 255 characters."
		echo -e "$thumbfile\n" >> $longnamelog
		return
	fi
	
	if [[ -e "$thumbfile" ]]; then
		mpcfind=$( mpc find albumartist "$artist" album "$album" | sed 's|\(.*\)/.*|\1|' | awk '!a[$0]++' )
		if (( $( echo "$mpcfind" | wc -l ) > 1 )); then
			(( dup++ ))
			echo -e "$padY Skip - $album - $artist duplicate"
			echo -e "$mpcfind\n" >> $duplog
			return
		elif [[ ! $removeexist ]]; then
			(( exist++ ))
			echo -e "$padW #$exist Skip - Thumbnail exists."
			return
		fi
	fi
	
	dummyfile=${thumbfile:0:-3}svg
	rm -f "$dummyfile"
	for cover in $coverfiles; do
		coverfile="$dir/$cover"
		if [[ -e "$coverfile" ]]; then
			convert "$coverfile" -thumbnail 200x200 -unsharp 0x.5 "$thumbfile"
			if [[ $? == 0 ]]; then
				if [[ $removeexist ]]; then
					(( replace++ ))
					echo -e "$padG #$prplace Replace - Existing thumbnail."
				else
					(( thumb++ ))
					echo -e "$padC #$thumb New - Thumbnail created from $cover"
				fi
				return
			fi
		fi
	done
	
	if [[ -z $cuefile ]]; then
		coverfile=$( $scandirphp "$dir" )
		if [[ ${coverfile:0:4} != '/srv' ]]; then
			echo "  $coverfile"
			return
		else
			convert "$coverfile" -thumbnail 200x200 -unsharp 0x.5 "$thumbfile"
			if [[ $? == 0 ]]; then
				if [[ $removeexist ]]; then
					(( replace++ ))
					echo -e "$padG #$replace Replace - Existing thumbnail."
				else
					(( thumb++ ))
					echo -e "$padC #$thumb New - Thumbnail created from embedded ID3."
				fi
				return
			fi
		fi
	fi

	ln -s /srv/http/assets/img/cover.svg "$dummyfile"
	(( dummy++ ))
	echo -e "$padGr #$dummy Dummy - No coverart found."
}

cue=
replace=0
exist=0
thumb=0
dummy=0
padGr=$( tcolor '.' 8 8 )
padW=$( tcolor '.' 7 7 )
padC=$( tcolor '.' 6 6 )
padY=$( tcolor '.' 3 3 )
padG=$( tcolor '.' 2 2 )
padR=$( tcolor '.' 1 1 )
imgcoverarts=/srv/http/assets/img/coverarts
coverfiles='cover.jpg cover.png folder.jpg folder.png front.jpg front.png Cover.jpg Cover.png Folder.jpg Folder.png Front.jpg Front.png'
nonutf8=0
longname=0
dup=0
nonutf8log=/root/list-nonutf8.log
longnamelog=/root/list-longnames.log
duplog=/root/list-duplicates.log
echo -e "Non-UTF8 Named Files - $( date +"%D %T" )\n" > $nonutf8log
echo -e "Too Long Named Files - $( date +"%D %T" )\n" > $longnamelog
echo -e "Duplicate Artist-Album - $( date +"%D %T" )\n" > $duplog

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
(( $replace )) && echo -e "$padG Replaced thumbnails  : $( tcolor $( numfmt --g $replace ) )"
(( $exist )) && echo -e   "$padW Existings thumbnails : $( numfmt --g $exist )"
(( $dummy )) && echo -e   "$padGr Dummy thumbnails     : $( tcolor $( numfmt --g $dummy ) )"
if (( $nonutf8 )); then
	echo -e               "$padR Non UTF-8 path       : $( tcolor $( numfmt --g $nonutf8 ) )  (See list in $( tcolor "$nonutf8log" ))"
else
	rm $nonutf8log
fi
if (( $longname )); then
	echo -e              "$padR Too long named       : $( tcolor $( numfmt --g $longname ) )  (See list in $( tcolor "$longnamelog" ))"
else
	rm $longnamelog
fi
if (( $dup )); then
	echo "$( awk '!NF || !seen[$0]++' $duplog | cat -s )" > $duplog # remove duplicate files
	dup=$(( $( grep -cve '^\s*$' $duplog ) - 1 )) # count without blank lines and less header
	echo -e              "$padY Duplicate albums     : $( tcolor $( numfmt --g $dup ) )  (See list in $( tcolor "$duplog" ))"
else
	rm $duplog
fi
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
