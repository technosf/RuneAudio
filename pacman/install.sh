#!/bin/bash

. /srv/http/addonstitle.sh

rankmirrors

packagestatus pacman # $version, $installed

if [[ $installed ]]; then
	title "$info Pacman already upgraded to latest version: $version"
	exit
fi

title -l '=' "$bar Upgrade Pacman ..."
timestart

if [[ ! -e /usr/lib/libcrypto.so.1.1 ]]; then
	wgetnc https://github.com/rern/RuneAudio/raw/master/mpd/usr/lib/libcrypto.so.1.1 -P /usr/lib
	wgetnc https://github.com/rern/RuneAudio/raw/master/mpd/usr/lib/libssl.so.1.1 -P /usr/lib
fi

echo -e "$bar Prefetch packages ..."
pacman -Syw --noconfirm glibc pacman

echo -e "$bar Install packages ..."
pacman -S --noconfirm glibc pacman

timestop

title -l '=' "$bar Pacman upgraded to $version successfully."
