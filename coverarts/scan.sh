#!/bin/bash

rm $0

. /srv/http/addonstitle.sh

pathcoverarts=$( redis-cli get pathcoverarts )
if [[ ! -e $pathcoverarts ]]; then
	title "$info Thumnail directory, $path, not exist."
	exit
fi

timestart

exist=0
thumb=0
dummy=0
pad=$( tcolor '.' 6 6 )
padB=$( tcolor '.' 4 4 )
padR=$( tcolor '.' 1 1 )
coverfiles=( cover.png cover.jpg folder.png folder.jpg front.png front.jpg Cover.png Cover.jpg Folder.png Folder.jpg Front.png Front.jpg )

function createThumbnail() {
	percent=$(( $i * 100 / $count ))
	echo -e "\n${percent}% $i/$count$cue - $( tcolor "$album" ) • $artist"
	
	# skip if non utf-8 found
	if [[ $( echo $thumbname | grep -axv '.*' ) ]]; then
		echo "$padR Name contains non UTF-8 characters."
		return
	fi
	
	thumbname=${thumbname//\//|} # slash "/" character not allowed in filename
	thumbfile="$pathcoverarts/$thumbname.jpg"
	
	if [[ -e "$thumbfile" ]]; then
		(( exist++ ))
		echo "  Thumbnail already exists."
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
				echo -e "$pad Thumbnail created from file: $coverfile"
				(( thumb++ ))
				return
			fi
		fi
	done
	
	if [[ !$cue ]]; then
		coverfile=$( /srv/http/enhanceID3cover.php "$file" )
		if [[ $coverfile != 0 ]]; then
			convert "$coverfile" -thumbnail 200x200 -unsharp 0x.5 "$thumbfile"
			if [[ $? == 0 ]]; then
				rm "$coverfile"
				echo -e "$pad Thumbnail created from embedded ID3: $file"
				(( thumb++ ))
				return
			fi
			rm "$coverfile"
		fi
	fi
	
	convert /srv/http/assets/img/cover-dummy.svg \
		-resize 200x200 \
		-font /srv/http/assets/fonts/lato/lato-regular-webfont.ttf \
		-pointsize 16 \
		-fill "#e0e7ee" \
		-annotate +10+90 "$album\n$artist" \
		"$thumbfile"
	echo -e "$padB Coverart not found. Dummy thumbnail created."
	(( dummy++ ))
}

title -l '=' "$bar Update / Create thumbnails for browsing by coverarts..."

sleep 2

# get album
listalbum=$( mpc list album | awk NF )
readarray -t albums <<<"$listalbum"
count=${#albums[@]}
echo "Album names : $( tcolor $count )"

# get album artist - expand albums with same name
title "$bar Get album list ..."

sleep 2

i=0
albumArtist=
for album in "${albums[@]}"; do
	find=$( mpc find -f "%album%^[%albumartist%|%artist%]" album "$album" | awk '!a[$0]++' )
	albumArtist="$albumArtist"$'\n'"$find"
	(( i++ ))
	percent=$(( $i * 100 / $count ))
	echo "${percent}% $i/$count - $album"
done
readarray -t albumArtists <<<"${albumArtist:1}" # remove 1st \n
echo -e "\n$( tcolor $( numfmt --g $i ) ) Album names"

title "$bar Get album-artist list ..."
# get album artist file
count=${#albumArtists[@]}
i=0
for albumArtist in "${albumArtists[@]}"; do
	album=$( echo "$albumArtist" | cut -d'^' -f1 )
	artist=$( echo "$albumArtist" | cut -d'^' -f2 )
	filempd=$( mpc find -f %file% album "$album" albumartist "$artist" | head -n1 )
	file=/mnt/MPD/$filempd
	dir=$( dirname "$file" )
	thumbname="$album^^$artist"
	(( i++ ))
	createThumbnail
done
countalbum=$i

# cue - not in mpd database
title "$bar Cue Sheet - Get album list ..."

sleep 2

cueFiles=$( find /mnt/MPD -type f -name '*.cue' )
readarray -t files <<<"$cueFiles"
count=${#files[@]}
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

#chown -R http:http $pathcoverarts

countalbum=$(( $countalbum + $i ))

echo -e "\n\n$pad New thumbnails     : $( tcolor $( numfmt --g $thumb ) )"
(( $dummy )) && echo -e "$padB Dummy thumbnails   : $( tcolor $( numfmt --g $dummy ) )"
(( $exist )) && echo -e "Existings/Duplicates : $( tcolor $( numfmt --g $exist ) )"
echo -e "Total Albums         : $( tcolor $( numfmt --g $countalbum ) )"

# save album count
redis-cli set countalbum $i &> /dev/null

curl -s -v -X POST 'http://localhost/pub?id=notify' -d '{ "title": "'"Coverart Browsing"'", "text": "'"Thumbnails updated."'" }' &> /dev/null

timestop

title -l '=' "$bar Thumbnails updated / created successfully."
echo -e "$bar To change:"
echo "  - Coverart files used before ID3 embedded"
echo "  - Replace coverart normally and update"
echo "  - Replace / Remove directly in $( tcolor /srv/http/assets/img/coverarts ) (200x200 px)"
title -nt "$info Start browsing: $( tcolor 'Library > Coverart' )"
