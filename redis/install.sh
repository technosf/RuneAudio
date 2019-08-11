#!/bin/bash

. /srv/http/addonstitle.sh

rankmirrors

packagestatus redis # $version, $installed

if [[ $installed ]]; then
	title "$info Redis already upgraded to latest version: $version"
	exit
fi

title -l '=' "$bar Upgrade Redis ..."
timestart

mv /etc/redis.conf{,.backup}

pacman -S --needeed --noconfirm redis

sed -i 's/^\(dbfilename \).*/\1rune.rdb/' /etc/redis.conf

if ! systemctl restart redis; then
	title -l = "$warn Redis upgrade failed."
	exit
fi

timestop

title -l '=' "$bar Redis upgraded to $version successfully."
