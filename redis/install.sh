#!/bin/bash

. /srv/http/addonstitle.sh

pkg=$( pacman -Ss '^redis$' | head -n1 )
version=$( echo $pkg | cut -d' ' -f2 )
installed=$( echo $pkg | cut -d' ' -f3 )

if [[ $installed == '[installed]' ]]; then
	title "$info Redis already upgraded to latest version: $version"
	exit
fi

title -l '=' "$bar Upgrade Redis ..."
timestart

pacman -S --noconfirm redis

sed -i -e 's/User=.*/User=root/
' -e 's/Group=.*/Group=root/
' -e '/CapabilityBoundingSet/,/LimitNOFILE/ d
' /lib/systemd/system/redis.service

systemctl daemon-reload
systemctl restart redis

timestop

title -l '=' "$bar Redis upgraded to $version successfully."
