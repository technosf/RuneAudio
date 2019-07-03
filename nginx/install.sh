#!/bin/bash

rm $0

. /srv/http/addonstitle.sh

if grep -q 'rewrite /css/(.*)   ' /etc/nginx/nginx.conf; then
	redis-cli hset addons ngin 1 &> /dev/null # mark as upgraded - disable button
	title "$info NGINX already upgraded."
	exit
fi

title -l '=' "$bar Upgrade NGINX ..."
timestart

echo -e "$bar Get NGINX packages ..."

file=nginx-1.16.0-1-armv7h.pkg.tar.xz
echo $file
wgetnc https://github.com/rern/RuneAudio/raw/master/nginx/$file

rm -r /etc/nginx/html
echo -e "y \n" | pacman -U $file
pacman -S --noconfirm iptables

rm $file
wgetnc https://github.com/rern/RuneAudio/raw/master/nginx/nginx.conf -P /etc/nginx
wgetnc https://github.com/rern/RuneAudio/raw/master/nginx/50x.html -P /srv/http
chown http:http /srv/http/50x.html

echo -e "$bar Restart NGINX ..."

restartnginx

timestop
title -l '=' "$bar NGINX upgraded successfully."
