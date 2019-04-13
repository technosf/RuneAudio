#!/bin/bash

[[ -n "$1" ]] && scanpath=$1
[[ -n "$2" ]] && removeexist=$2

#rm $0

. /srv/http/addonstitle.sh

timestart

exist=0
thumb=0
dummy=0
nonutf8=0
padW=$( tcolor '.' 7 7 )
padC=$( tcolor '.' 6 6 )
padB=$( tcolor '.' 4 4 )
padR=$( tcolor '.' 1 1 )

[[ -n $( ls /srv/http/assets/img/coverarts ) ]] && update=Update || update=Create
coloredname=$( tcolor 'Browse By Directory CoverArt' )

title -l '=' "$bar $update thumbnails for $coloredname ..."

echo -e "$bar Update Library database ..."

title "$bar Get directory list ..."

[[ -v scanpath ]] && path=$1 || path=/mnt/MPD
imgcoverarts=/srv/http/assets/img/coverarts
find=$( find "$path" -type d )
if [[ -z $find ]]; then
	title "$info No directories found in $1"
	exit
fi

# create temporary file to let bash run php with arguments
cat << 'EOF' > /tmp/scandir.php
#!/usr/bin/php
<?php
require_once( '/srv/http/enhancegetcover.php' );
echo getThumbnail( $argv[ 1 ], 'scancover' );
EOF
chmod +x /tmp/scandir.php

readarray -t dirs <<<"$find"
count=${#dirs[@]}
echo -e "\n$( tcolor $( numfmt --g $count ) ) Directories"
i=0
for dir in "${dirs[@]}"; do
	(( i++ ))
	percent=$(( $i * 100 / $count ))
	echo
	mpdpath=${dir:9}
	echo ${percent}% $( tcolor "$i/$count" 8 ) $( tcolor "$mpdpath" )
	
	# skip if non utf-8 found
	if [[ $( echo $mpdpath | grep -axv '.*' ) ]]; then
		echo "$padR Directory path contains non UTF-8 characters."
		(( nonutf8++ ))
		continue
	fi
	
	# "/" not allowed in filename, "#" and "?" not allowed in img src
	thumbname=$( echo $mpdpath | sed 's|/|\||g; s/#/{/g; s/?/}/g' )
	thumbfile=$imgcoverarts/${thumbname//\//|}.jpg
	if [[ ! -v removeexist && -e "$thumbfile" ]]; then
		(( exist++ ))
		echo "  Skip - Thumbnail exists."
		continue
	fi
	
	created=0
	coverfile=$( /tmp/scandir.php "$dir" )
	if [[ $coverfile != 0 ]]; then
		echo $coverfile
		echo $thumbfile
#		convert "$coverfile" -thumbnail 200x200 -unsharp 0x.5 "$thumbfile"
		if [[ $? == 0 ]]; then
			chown http:http "$thumbfile"
			echo -e "$padC Thumbnail created."
			(( thumb++ ))
			created=1
		fi
	fi
	if [[ ! $created ]]; then
		thumbfile=${thumbfile:0:-3}svg
#		ln -s /srv/http/assets/img/cover.svg "$thumbfile"
		chown -h http:http "$thumbfile"
		echo -e "$padB Coverart not found."
		(( dummy++ ))
	fi
done

rm /tmp/scandir.php

echo -e               "\n\n$padC New thumbnails     : $( tcolor $( numfmt --g $thumb ) )"
(( $dummy )) && echo -e   "$padB Dummy thumbnails   : $( tcolor $( numfmt --g $dummy ) )"
(( $nonutf8 )) && echo -e "$padR Non UTF-8 path     : $( tcolor $( numfmt --g $nonutf8 ) )"
(( $exist )) && echo -e       "Existings thumbnails : $( tcolor $( numfmt --g $exist ) )"
[[ -v scanpath ]] && echo -e  "Update directory     : $( tcolor "$scanpath" )"

curl -s -v -X POST 'http://localhost/pub?id=notify' \
	-d '{ "title": "'"Browse By CoverArt"'", "text": "'"Thumbnails ${update}d."'" }' \
	&> /dev/null

timestop

title -l '=' "$bar Thumbnails for $coloredname ${update}d successfully."

echo
echo Thumbnails directory : $( tcolor "$imgcoverarts" )
echo
echo -e "$bar To change individually:"
echo "    - CoverArt > long-press thumbnail > Delete / Replace icon"
echo -e "$bar To update with database:"
echo "    - Full    - Library > long-press CoverArt"
echo "    - Partial - Library > directory > context menu > Update thumbnails"
