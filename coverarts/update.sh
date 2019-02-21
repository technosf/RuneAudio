#!/bin/bash

rm $0

. /srv/http/addonstitle.sh

pathcoverarts=$( redis-cli get pathcoverarts )
if [[ ! -e $pathcoverarts ]]; then
	title "$info Thumnail directory, $path, not exist."
	exit
fi

title -l '=' "$bar Update / Create thumbnails for browsing by coverarts..."

timestart

coverfiles=( cover.png cover.jpg folder.png folder.jpg front.png front.jpg Cover.png Cover.jpg Folder.png Folder.jpg Front.png Front.jpg )
exist=0
thumb=0
dummy=0
pad=$( tcolor '.' 6 6 )
pad4=$( tcolor '.' 4 4 )


# get album
listalbum=$( mpc list album | awk NF )
readarray -t albums <<<"$listalbum"

# get album artist - expand albums with same name
echo -e "$bar Get album list ...\n"
count=${#albums[@]}
i=0
albumArtist=
for album in "${albums[@]}"; do
	find=$( mpc find -f "%album%^[%albumartist%|%artist%]" album "$album" | awk '!a[$0]++' )
	albumArtist="$albumArtist"$'\n'"$find"
	(( i++ ))
	(( $i == 10 )) && break
	percent=$(( $i * 100 / $count ))
	echo -en "\r\033[K${percent}% - $album"
done
readarray -t albumArtists <<<"${albumArtist:1}" # remove 1st \n
echo -en "\r\033[K"
echo -e "$( tcolor $i ) Albums"

echo -e "\n\n$bar Get album-artist list ...\n"
# get album artist file
count=${#albumArtists[@]}
i=0
albumArtistFile=
for albumArtist in "${albumArtists[@]}"; do
	album=$( echo "$albumArtist" | cut -d'^' -f1 )
	artist=$( echo "$albumArtist" | cut -d'^' -f2 )
	filempd=$( mpc find -f %file% album "$album" artist "$artist" | head -n1 )
	file=/mnt/MPD/$filempd
	dir=$( dirname "$file" )
	thumbname=${albumArtist//\//|} # slash "/" character not allowed in filename
	thumbname=${albumArtist/^/^^} # slash "/" character not allowed in filename
	thumbfile=$pathcoverarts/$thumbname.jpg
	(( i++ ))
	percent=$(( $i * 100 / $count ))
	echo -e "\n${percent}% $i/$count - $( tcolor "$album" ) • $artist"
	if [[ -e $thumbfile ]]; then
		echo "  Thumbnail already exists."
		(( exist++ ))
		continue
	fi
	
	for cover in "${coverfiles[@]}"; do
		coverfile=$dir/$cover
		if [[ -e $coverfile ]]; then
			convert "$coverfile" \
				-thumbnail 200x200 \
				-unsharp 0x.5 \
				"$thumbfile"
			(( thumb++ ))
			created=1
			echo -e "  $pad Thumbnail created from file: $coverfile"
			break
		fi
	done
	[[ $created ]] && continue
	
	coverfile=$( /srv/http/enhanceID3cover.php "$file" )
	echo $file
	echo $coverfile
	exit
	if [[ $coverfile != 0 ]]; then
		convert "$coverfile" -thumbnail 200x200 -unsharp 0x.5 "$thumbfile"
		rm "$coverfile"
		echo -e "  $pad Thumbnail created from embedded ID3: $file"
		(( thumb++ ))
		continue
	fi
	anotate=$album\n$artist\n$filempd
	convert /srv/http/assets/img/cover-dummy.svg \
		-resize 200x200 \
		-font /srv/http/assets/fonts/lato/lato-regular-webfont.ttf \
		-pointsize 16 \
		-fill "#e0e7ee" \
		-annotate +10+85 "$anotate" \
		"$thumbfile"
	echo -e "  $pad4 Coverart not found. Dummy thumbnail created."
	(( dummy++ ))
done

timestop

title "$bar Thumbnails updated and saved at $( tcolor "$pathcoverarts" )"
title -nt "Refresh browser > $( tcolor 'Library Coverart' )"
