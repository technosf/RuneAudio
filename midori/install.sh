#!/bin/bash

. /srv/http/addonstitle.sh

rankmirrors

packagestatus midori # $version, $installed

if [[ $installed ]]; then
	title "$info Midori already upgraded to latest version: $version"
	exit
fi

title -l '=' "$bar Upgrade Midori ..."
timestart

if ! pacman -Q midori-rune &> /dev/null; then
	file=$( ls -l /lib/libicuuc* | grep -v '^lrw' )
	file=$( echo $file | cut -d' ' -f9 )
	ln -sf $file /lib/libicuuc.so.56

	file=$( ls -l /lib/libicudata* | grep -v '^lrw' )
	file=$( echo $file | cut -d' ' -f9 )
	ln -sf $file /lib/libicudata.so.56
fi

rankmirrors

pacman -S --noconfirm midori

if grep '^chromium' /root/.xinitrc; then
	echo -e "$bar Disable Chromium ..."
	sed -i -e '/^chromium/ s/^/#/
	' -e '/midori/ s/^#//
	' /root/.xinitrc
fi

echo -e "$bar Restart Midori ..."
killall midori
sleep 3
xinit &> /dev/null &

timestop

title -l '=' "$bar Midori upgraded to $version successfully."

