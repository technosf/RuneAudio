#!/bin/bash

[[ -n "$1" ]] && scanpath=$1
[[ -n "$2" ]] && removeexist=$2

rm $0

. /srv/http/addonstitle.sh

timestart

#################### to be removed ########################################
# verify coverarts directory
pathcoverarts=$( readlink -f /srv/http/assets/img/coverarts )

if [[ -e "$pathcoverarts" ]]; then # exist and writable
	touch "$pathcoverarts/0"
	if [[ $? != 0 ]]; then
		title "$info Directory $( tcolor "$pathcoverarts" ) is not writable."
		title -nt "Set write permission then try again."
		exit
	fi
	rm "$pathcoverarts/0"
elif [[ ! -e "$pathcoverarts" || ! $pathcoverarts ]]; then # not exist or not set
	pathcoverarts=$( find /mnt/MPD/ -maxdepth 3 -type d -name coverarts )
	if (( $( echo "$pathcoverarts" | wc -l ) > 1 )); then # more than 1 found
		title "$info Directory $( tcolor coverarts ) found more than 1 at:"
		echo "$pathcoverarts"
		title -nt "Keep one to use and rename others."
		exit
	fi
	if [[ $pathcoverarts ]]; then # exist > recreate link and set redis
		touch "$pathcoverarts/0"
		if [[ $? != 0 ]]; then
			title "$info Directory $( tcolor "$pathcoverarts" ) found but not writable."
			title -nt "Set write permission then try again."
			exit
		fi
		rm "$pathcoverarts/0"
	else
		echo -e "$bar Create coverarts directory ..."

		pathcoverarts=/mnt/MPD/LocalStorage/coverarts
		df=$( df )
		dfUSB=$( echo "$df" | grep '/mnt/MPD/USB' | head -n1 )
		dfNAS=$( echo "$df" | grep '/mnt/MPD/NAS' | head -n1 )
		if [[ $dfUSB || $dfNAS ]]; then
			[[ $dfUSB ]] && mount=$dfUSB || mount=$dfNAS
			mnt=$( echo $mount | awk '{ print $NF }' )
			touch $mnt/0
			if [[ $? == 0 ]]; then
				pathcoverarts="$mnt/coverarts"
				rm $mnt/0
			fi
		fi
		mkdir -p "$pathcoverarts"
	fi
fi
ln -sf "$pathcoverarts" /srv/http/assets/img/
####################################################################################################

if ! pacman -Q imagemagick &> /dev/null; then
	pacman -Sy imagemagick libpng zlib glibc
fi
if ! pacman -Q imagemagick &> /dev/null; then
	title "$info $( tcolor ImageMagick ) install failed."
	title -nt "Try again later."
	exit
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
coverfiles='cover.jpg cover.png folder.jpg folder.png front.jpg front.png Cover.jpg Cover.png Folder.jpg Folder.png Front.jpg Front.png'

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
	
	# "/" not allowed in filename, "#" and "?" not allwed in img src
	thumbname=$( echo $thumbname | sed 's|/|\||g; s/#/{/g; s/?/}/g' )
	thumbfile="$pathcoverarts/$thumbname.jpg"
	
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
	
	if [[ !$cue || !$wav ]]; then
		coverfile=$( /srv/http/enhanceID3cover.php "$file" )
		if [[ $coverfile != 0 ]]; then
			convert "$coverfile" -thumbnail 200x200 -unsharp 0x.5 "$thumbfile"
			if [[ $? == 0 ]]; then
				rm "$coverfile"
				echo -e "$padC Thumbnail created - ID3: $file"
				(( thumb++ ))
				return
			fi
			rm "$coverfile"
		fi
	fi
	
	ln -s /srv/http/assets/img/cover.svg "${thumbfile:0:-3}svg"
	echo -e "$padB Coverart not found."
	(( dummy++ ))
}

[[ $( redis-cli exists countalbum ) == 1 ]] && update=Update || update=Create
coloredname=$( tcolor 'Browse By CoverArt' )

title -l '=' "$bar $update thumbnails for $coloredname ..."

echo -e "$bar Update Library database ..."
mpc update | head -n1

title "$bar Get album-artist list ..."

if [[ -v scanpath ]]; then
######### base: specific path
	find=$( find "$1" -type d )
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
		mpcls=$( mpc ls -f "%album%^[%albumartist%|%artist%]" "$path" | grep '\^' | awk '!a[$0]++' )
		(( i++ ))
		percent=$(( $i * 100 / $count ))
		echo ${percent}% $( tcolor "$i/$count dir" 8 ) $path
		[[ -z $mpcls ]] && continue
		albumArtist="$albumArtist"$'\n'"$mpcls"
	done
	albumArtist=$( echo "$albumArtist" | awk '!a[$0]++' )
else
######### base: database
	# get album names
	listalbum=$( mpc list album | awk NF )
	if [[ -z $listalbum ]]; then
		title "$info No albums found in database"
		exit
	fi
	readarray -t albums <<<"$listalbum"
	count=${#albums[@]}
	echo -e "\n$( tcolor $( numfmt --g $count ) ) Album names"
	albumnames=$count

	# expand albums with same name
	title "$bar Get album-artist list ..."

	i=0
	albumArtist=
	for album in "${albums[@]}"; do
		find=$( mpc find -f "%album%^[%albumartist%|%artist%]" album "$album" | awk '!a[$0]++' )
		albumArtist="$albumArtist"$'\n'"$find"
		(( i++ ))
		percent=$(( $i * 100 / $count ))
		echo ${percent}% $( tcolor "$i/$count name" 8 ) $album
	done
fi
readarray -t albumArtists <<<"${albumArtist:1}" # remove 1st \n
count=${#albumArtists[@]}
countalbum=$count

# get path of each album > get coverart > create
title "$bar Get files ..."
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
[[ $1 ]] && path=$1 || path=/mnt/MPD
cueFiles=$( find "$path" -type f -name '*.cue' )
if [[ -n $cueFiles ]]; then
	readarray -t files <<<"$cueFiles"
	count=${#files[@]}
	title "$bar Cue Sheet - Get album list ..."

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
fi

chown -R http:http "$pathcoverarts" /srv/http/assets/img/coverarts

echo -e "\n\n$padC New thumbnails     : $( tcolor $( numfmt --g $thumb ) )"
(( $dummy )) && echo -e "$padB Dummy thumbnails   : $( tcolor $( numfmt --g $dummy ) )"
(( $nonutf8 )) && echo -e "$padR Non UTF-8 names    : $( tcolor $( numfmt --g $nonutf8 ) )"
(( $exist )) && echo -e "Existings thumbnails : $( tcolor $( numfmt --g $exist ) )"
if [[ -v scanpath ]]; then
	echo -e "Update directory     : $( tcolor "$( basename "$scanpath" )" )"
else
	echo -e "Album names          : $( tcolor $( numfmt --g $albumnames ) )"
	echo -e "$padW Total albums       : $( tcolor $( numfmt --g $countalbum ) )"
	# save album count
	redis-cli set countalbum $countalbum &> /dev/null
fi

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
echo "    - Replace - manage coverarts normally and update (Coverart files used before ID3 embedded)"
echo "    - Delete  - long-press on each thumbnail"
echo -e "$bar To update :"
echo "    - Full    - Library > long-press $( tcolor CoverArt )"
echo "    - Partial - Library > directory > Context menu > Update thumbnails"
