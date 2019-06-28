#!/bin/bash

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=ngin

. /srv/http/addonstitle.sh

if grep -q 'rewrite /css/(.*)   ' /etc/nginx/nginx.conf; then
	redis-cli hset addons ngin 1 &> /dev/null # mark as upgraded - disable button
	title "$info NGINX already upgraded."
	exit
fi

title -l '=' "$bar Upgrade NGINX ..."
timestart

# backup
mv /etc/nginx/html/50x.html{.backup,}

echo -e "$bar Get NGINX packages ..."

file=nginx-1.16.0-1-armv7h.pkg.tar.xz
echo $file
wgetnc https://github.com/rern/RuneAudio/raw/master/nginx/$file

echo -e "y \n" | pacman -U $file
pacman -Sy iptables

rm $file
wgetnc https://github.com/rern/RuneAudio/raw/master/nginx/nginx.conf -P /etc/nginx
mv /etc/nginx/html/50x.html{,.backup}

redis-cli hset addons ngin 1 &> /dev/null # mark as upgraded - disable button

echo -e "$bar Restart NGINX ..."

restartnginx

timestop
title -l '=' "$bar NGINX upgraded successfully."
