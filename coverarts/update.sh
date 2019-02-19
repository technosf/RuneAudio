#!/bin/bash

rm $0

. /srv/http/addonstitle.sh

if ! find /mnt/MPD -name 'coverarts' -type d; then
	title "$info Directory 'coverarts' not exist."
	exit
fi

title -l '=' "$bar Update / Create coverarts for browsing ..."

timestart

albums=$( mpc stats | grep Albums | awk '{ print $NF }' )
minutes=(( $album / 5 ))
echo -e "$bar This may take up to $minutes minutes for $albums albums ..."

wgetnc https://github.com/rern/RuneAudio/raw/master/coverarts/enhancecoverart.php
chmod +x enhancecoverart.php
./enhancecoverart.php

timestop

title "$bar Update / Create coverarts completed."
