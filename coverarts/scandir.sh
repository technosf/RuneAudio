#!/bin/bash

[[ -n "$1" ]] && scanpath=$1
[[ -n "$2" ]] && removeexist=$2

rm $0

. /srv/http/addonstitle.sh

timestart

exist=0
thumb=0
dummy=0
padW=$( tcolor '.' 7 7 )
padC=$( tcolor '.' 6 6 )
padB=$( tcolor '.' 4 4 )
padR=$( tcolor '.' 1 1 )
coverfiles='cover.jpg cover.png folder.jpg folder.png front.jpg front.png Cover.jpg Cover.png Folder.jpg Folder.png Front.jpg Front.png'

function createThumbnail() {
	percent=$(( $i * 100 / $count ))
	echo
	echo ${percent}% $( tcolor "$i/$count" 8 ) $( tcolor "$thumbname" )
	
	# "/" not allowed in filename, "#" and "?" not allowed in img src
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
	
	find=$( find "$dir" -maxdepth 1 -type f )
	if [[ -n $find ]]; then
		readarray -t files <<<"$find"
		for file in "${files[@]}"; do
			mime=$( file -b --mime-type $file | cut -c1-5 )
			if [[ $mime == audio ]]; then
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
		done
	fi
	
	ln -s /srv/http/assets/img/cover.svg "${thumbfile:0:-3}svg"
	echo -e "$padB Coverart not found."
	(( dummy++ ))
	return
}

[[ -n $( ls /srv/http/assets/img/coverarts ) ]] && update=Update || update=Create
coloredname=$( tcolor 'Browse By Directory CoverArt' )

title -l '=' "$bar $update thumbnails for $coloredname ..."

echo -e "$bar Update Library database ..."
mpc update | head -n1

title "$bar Get directory list ..."

[[ -v scanpath ]] && path=$1 || path=/mnt/MPD
find=$( find "$path" -type d )
if [[ -z $find ]]; then
	title "$info No music files found in $1"
	exit
fi
readarray -t dirs <<<"$find"
count=${#dirs[@]}
echo -e "\n$( tcolor $( numfmt --g $count ) ) Directories"
i=0
for dir in "${dirs[@]}"; do
	thumbname=${dir/\/mnt\/MPD\/}
	(( i++ ))
	createThumbnail
done

chown -R http:http "$pathcoverarts" /srv/http/assets/img/coverarts

echo -e "\n\n$padC New thumbnails     : $( tcolor $( numfmt --g $thumb ) )"
(( $dummy )) && echo -e "$padB Dummy thumbnails   : $( tcolor $( numfmt --g $dummy ) )"
(( $exist )) && echo -e "Existings thumbnails : $( tcolor $( numfmt --g $exist ) )"
if [[ -v scanpath ]]; then
	echo -e "Update directory     : $( tcolor "$( basename "$scanpath" )" )"
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
