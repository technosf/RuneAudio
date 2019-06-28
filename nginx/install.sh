#!/bin/bash

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=ngin

. /srv/http/addonstitle.sh

if [[ $( nginx -v ) == 'nginx version: nginx/1.16.0' ]]; then
	redis-cli hset addons ngin 1 &> /dev/null # mark as upgraded - disable button
	title "$info NGINX already upgraded."
	exit
fi

title -l '=' "$bar Upgrade NGINX ..."
timestart

# backup
mv /etc/nginx/mime.types{,.backup}
mv /etc/nginx/nginx.conf{,.backup}
mv /usr/lib/systemd/system/nginx.service{,.backup}

echo -e "$bar Get NGINX packages ..."

file=nginx-1.16.0-1-armv7h.pkg.tar.xz
echo $file
wgetnc https://github.com/rern/RuneAudio/raw/master/nginx/$file

pacman -U --noconfirm $file
pacman -Sy iptables

rm $file
mv /etc/nginx/nginx.conf{.backup,}
mv /etc/nginx/nginx.conf{.backup,}
mv /usr/lib/systemd/system/nginx.service{.backup,}

lnfile=$( find /lib/libevent* -type f | grep '.*/libevent-.*' )
ln -sf $lnfile /lib/libevent-2.0.so.5

systemctl daemon-reload

redis-cli hset addons ngin 1 &> /dev/null # mark as upgraded - disable button

echo -e "$bar Restart NGINX ..."

restartnginx

timestop
title -l '=' "$bar NGINX upgraded successfully."
