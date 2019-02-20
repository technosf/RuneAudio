#!/bin/bash

rm $0

. /srv/http/addonstitle.sh

path=$( redis-cli get pathcoverarts )
if [[ ! -e $path ]]; then
	title "$info Create coverarts directory ..."

	df=$( df )
	dfUSB=$( echo "$df" | grep '/mnt/MPD/USB' | head -n1 )
	dfNAS=$( echo "$df" | grep '/mnt/MPD/NAS' | head -n1 )
	pathcoverarts=/mnt/MPD/LocalStorage/coverarts
	if [[ $dfUSB ]]; then
		mnt=$( echo $dfUSB | awk '{ print $NF }' )
		pathcoverarts=$mnt/coverarts
	elif [[ $dfNAS ]]; then
		mnt=$( echo $dfNAS | awk '{ print $NF }' )
		acl=$( getfacl $mnt | grep user | cut -d':' -f3 )
		[[ ${acl:0:2} == rw ]] && pathcoverarts=$mnt/coverarts
	fi
	mkdir -p $pathcoverarts
	pathlink=/srv/http/assets/img/coverarts
	ln -sf $path /srv/http/assets/img/coverarts
	chown http:http $pathcoverarts $pathlink
	chmod 644 $pathcoverarts pathlink

	redis-cli set pathcoverarts $pathcoverarts$path
fi

title -l '=' "$bar Update / Create thumbnails for browsing by coverarts..."

timestart

wgetnc https://github.com/rern/RuneAudio/raw/master/coverarts/enhancecoverart.php
chmod +x enhancecoverart.php
./enhancecoverart.php

timestop

title "$bar Thumbnails updated/created and saved at \e[36m$pathcoverarts\e[0m"
title -nt "Refresh browser > \e[36mLibrary Coverart\e[0m"
