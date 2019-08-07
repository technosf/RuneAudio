#!/bin/bash

rm $0

. /srv/http/addonstitle.sh

title -l '=' "$bar Upgrade NGINX ..."
timestart

echo -e "$bar Get NGINX packages ..."

file=nginx-1.16.0-1-armv7h.pkg.tar.xz
echo $file
wgetnc https://github.com/rern/RuneAudio/raw/master/nginx/$file

rm -r /etc/nginx/html
echo -e "y \n" | pacman -U $file
pacman -S --noconfirm iptables
ln -s /lib/libip4tc.so.{2.0.0,0}

rm $file
wgetnc https://github.com/rern/RuneAudio/raw/master/nginx/nginx.conf -P /etc/nginx
wgetnc https://github.com/rern/RuneAudio/raw/master/nginx/50x.html -P /etc/nginx/html

echo -e "$bar Restart NGINX ..."

restartnginx

timestop
title -l '=' "$bar NGINX upgraded successfully."
