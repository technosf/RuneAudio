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
sed -i 's/^After=.*/After=enhancestartup.service/' /usr/lib/systemd/system/redis.service

if ! systemctl restart redis; then
	title -l = "$warn Redis upgrade failed."
	exit
fi

timestop

version=$( redis-cli -v | cut -d' ' -f2 )

title -l '=' "$bar Redis upgraded successfully to $version"
