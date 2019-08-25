#!/bin/bash

rm $0

. /srv/http/addonstitle.sh

rankmirrors

packagestatus mpd # $version, $installed

if [[ $installed ]]; then
	title "$info MPD already upgraded to latest version: $version"
	exit
fi

title -l '=' "$bar Upgrade MPD ..."
timestart

	pacman -S --needed --noconfirm mpd
if systemctl restart mpd mpdidle &> /dev/null; then
	timestop
	title -l '=' "$bar MPD upgraded successfully to $version"
else
	title -l = "$warn MPD upgrade failed."
fi
