#!/bin/bash

rm $0

. /srv/http/addonstitle.sh

path=$( redis-cli get pathcoverarts )
if [[ ! -e $path ]]; then
	title "$info Directory: $path not exist."
	exit
fi

title -l '=' "$bar Update / Create coverarts for browsing ..."

timestart

albums=$( mpc stats | grep Albums | awk '{ print $NF }' )
minutes=$(( albums / 3 / 60 ))
echo -e "$bar This may take up to $minutes minutes for $albums albums ..."

wgetnc https://github.com/rern/RuneAudio/raw/master/coverarts/enhancecoverart.php
chmod +x enhancecoverart.php
./enhancecoverart.php

timestop

title "$bar Thumbnails updated/created and saved at \e[36m$pathcoverarts\e[0m"
title -nt "Refresh browser > \e[36mLibrary Coverart\e[0m"
