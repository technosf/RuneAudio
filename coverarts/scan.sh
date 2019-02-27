#!/bin/bash

rm $0

. /srv/http/addonstitle.sh

timestart

# verify coverarts directory
if [[ $# -eq 1 && $1 != 0 ]];then
	pathcoverarts=$1
	redis-cli set pathcoverarts "$pathcoverarts" &> /dev/null
else
	pathcoverarts=$( redis-cli get pathcoverarts )
fi
if [[ -e "$pathcoverarts" ]]; then # exist and writable
	touch "$pathcoverarts/0"
	if (( $? != 0 )); then
		title "$info Directory $( tcolor "$pathcoverarts" ) is not writeable."
		title -nt "Enable write permission then try again."
		exit
	fi
	rm "$pathcoverarts/0"
elif [[ ! -e "$pathcoverarts" || ! $pathcoverarts ]]; then # not exist or not set
	pathcoverarts=$( find /mnt/MPD/ -maxdepth 3 -type d -name coverarts )
	if (( $( echo "$pathcoverarts" | wc -l ) > 1 )); then # more than 1 found
		title "$info Directory $( tcolor coverarts ) found more than 1 at:"
		echo "$pathcoverarts"
		title -nt "Keep the one to be used and rename others."
		exit
	fi
	if [[ $pathcoverarts ]]; then # exist > recreate link and set redis
		ln -sf "$pathcoverarts" /srv/http/assets/img/
		redis-cli set pathcoverarts "$pathcoverarts" &> /dev/null
		touch "$pathcoverarts/0"
		if (( $? != 0 )); then
			title "$info Directory $( tcolor "$pathcoverarts" ) found but not writeable."
			title -nt "Enable write permission then try again."
			exit
		fi
		rm "$pathcoverarts/0"
	else
		echo -e "$bar Create coverarts directory ..."

		df=$( df )
		dfUSB=$( echo "$df" | grep '/mnt/MPD/USB' | head -n1 )
		dfNAS=$( echo "$df" | grep '/mnt/MPD/NAS' | head -n1 )
		if [[ $dfUSB || $dfNAS ]]; then
			[[ $dfUSB ]] && mount=$dfUSB || mount=$dfNAS
			mnt=$( echo $mount | awk '{ print $NF }' )
			pathcoverarts="$mnt/coverarts"
			mkdir "$pathcoverarts"
			if (( $? != 0 )); then
				pathcoverarts=/mnt/MPD/LocalStorage/coverarts
				mkdir "$pathcoverarts"
			fi
			ln -sf "$pathcoverarts" /srv/http/assets/img/
			redis-cli set pathcoverarts "$pathcoverarts" &> /dev/null
		fi
	fi
fi

cue=
exist=0
thumb=0
dummy=0
nonutf8=0
padW=$( tcolor '.' 7 7 )
padC=$( tcolor '.' 6 6 )
padB=$( tcolor '.' 4 4 )
padR=$( tcolor '.' 1 1 )
coverfiles=( cover.png cover.jpg folder.png folder.jpg front.png front.jpg Cover.png Cover.jpg Folder.png Folder.jpg Front.png Front.jpg )

rm -f /srv/http/tmp/skipped-wav.txt # remove log

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
	
	thumbname=${thumbname//\//|} # slash "/" character not allowed in filename
	thumbfile="$pathcoverarts/$thumbname.jpg"
	if [[ -e "$thumbfile" ]]; then
		(( exist++ ))
		echo "  Skip - Thumbnail already exists."
		return
	fi
	
	for cover in "${coverfiles[@]}"; do
		coverfile="$dir/$cover"
		if [[ -e "$coverfile" ]]; then
			convert "$coverfile" \
				-thumbnail 200x200 \
				-unsharp 0x.5 \
				"$thumbfile"
			if [[ $? == 0 ]]; then
				echo -e "$padC Thumbnail created from file: $coverfile"
				(( thumb++ ))
				return
			fi
		fi
	done
	
	if [[ !$cue || !$wav ]]; then
		coverfile=$( /srv/http/enhanceID3cover.php "$file" )
		if [[ $coverfile != 0 ]]; then
			convert "$coverfile" -thumbnail 200x200 -unsharp 0x.5 "$thumbfile"
			if [[ $? == 0 ]]; then
				rm "$coverfile"
				echo -e "$padC Thumbnail created from embedded ID3: $file"
				(( thumb++ ))
				return
			fi
			rm "$coverfile"
		fi
	fi
	
	[[ -n $artist ]] && anotate="$album\n$artist" || anotate=$album
	convert /srv/http/assets/img/cover-dummy.svg \
		-resize 200x200 \
		-font /srv/http/assets/fonts/lato/lato-regular-webfont.ttf \
		-pointsize 16 \
		-fill "#e0e7ee" \
		-annotate +10+90 "$anotate" \
		"$thumbfile"
	echo -e "$padB Coverart not found. Dummy thumbnail created."
	(( dummy++ ))
}

[[ $( redis-cli exists countalbum ) == 1 ]] && update=Update || update=Create
coloredname=$( tcolor 'Browsing By Coverart' )

title -l '=' "$bar $update thumbnails for $coloredname ..."

# get album
listalbum=$( mpc list album | awk NF )
readarray -t albums <<<"$listalbum"
count=${#albums[@]}
albumnames=$count

# get album artist - expand albums with same name
title "$bar Get album list ..."

i=0
albumArtist=
for album in "${albums[@]}"; do
	find=$( mpc find -f "%album%^[%albumartist%|%artist%]" album "$album" | awk '!a[$0]++' )
	albumArtist="$albumArtist"$'\n'"$find"
	(( i++ ))
	percent=$(( $i * 100 / $count ))
	echo ${percent}% $( tcolor "$i/$count" 8 ) $album
done
readarray -t albumArtists <<<"${albumArtist:1}" # remove 1st \n
echo -e "\n$( tcolor $( numfmt --g $i ) ) Album names"

title "$bar Get album-artist list ..."
# get album artist file
count=${#albumArtists[@]}
countalbum=$count
i=0
for albumArtist in "${albumArtists[@]}"; do
	album=$( echo "$albumArtist" | cut -d'^' -f1 )
	artist=$( echo "$albumArtist" | cut -d'^' -f2 )
	filempd=$( mpc find -f %file% album "$album" albumartist "$artist" | head -n1 )
	file=/mnt/MPD/$filempd
	dir=$( dirname "$file" )
	if [[ $dir == $dirwav ]]; then
		echo "  Skip - *.wav in the same directory."
		(( countalbum-- ))
		echo "$file" >> '/srv/http/tmp/skipped-wav.txt'
		continue
	fi
	
	if [[ ${file##*.} == wav ]]; then
		wav=1
		dirwav=$dir
		thumbname="$album^^"
	else
		wav=0
		thumbname="$album^^$artist"
	fi
	(( i++ ))
	createThumbnail
done

# cue - not in mpd database
title "$bar Cue Sheet - Get album list ..."

cueFiles=$( find /mnt/MPD -type f -name '*.cue' )
readarray -t files <<<"$cueFiles"
count=${#files[@]}
countalbum=$(( countalbum + count ))
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

echo -e "\n\n$padC New thumbnails     : $( tcolor $( numfmt --g $thumb ) )"
(( $dummy )) && echo -e "$padB Dummy thumbnails   : $( tcolor $( numfmt --g $dummy ) )"
(( $nonutf8 )) && echo -e "$padR Non UTF-8 names    : $( tcolor $( numfmt --g $nonutf8 ) )"
(( $exist )) && echo -e "Existings            : $( tcolor $( numfmt --g $exist ) )"
echo -e "Album names          : $( tcolor $( numfmt --g $albumnames ) )"
echo -e "$padW Total albums       : $( tcolor $( numfmt --g $countalbum ) )"

# save album count
redis-cli set countalbum $countalbum &> /dev/null

curl -s -v -X POST 'http://localhost/pub?id=notify' -d '{ "title": "'"Coverart Browsing"'", "text": "'"Thumbnails updated."'" }' &> /dev/null

timestop

title -l '=' "$bar Thumbnails for $coloredname ${update}d successfully."

if [[ $( echo $pathcoverarts | cut -d'/' -f4 ) == LocalStorage ]]; then
	echo -e "$info $( tcolor $pathcoverarts ) is in SD card. Backup before reflash."
fi
echo
echo Thumbnails directory : $( tcolor "$pathcoverarts" )
echo
echo -e "$bar To change :"
echo "  - Coverart files used before ID3 embedded"
echo "  - Replace coverart normally and update"
echo "  - Delete by long-press on each thumbnail"
echo -e "$bar To update : Long-press $( tcolor CoverArt ) in Library"
