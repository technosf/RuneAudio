#!/bin/bash

# import heading function
wget -qN https://github.com/rern/title_script/raw/master/title.sh; . title.sh; rm title.sh

if [[ ! -e /srv/http/assets/fonts/latobackup ]]; then
	echo -e "$info Extended fonts not found."
	exit
fi

title -l = "$bar Unnstall Extended fonts ..."
rm -rv /srv/http/assets/fonts/lato
mv /srv/http/assets/fonts/lato{backup,}

redis-cli hset addons font 0 &> /dev/null

# refresh #######################################
echo -e "$bar Clear PHP OPcache ..."
systemctl reload php-fpm
echo

if pgrep midori >/dev/null; then
	killall midori
	sleep 1
	xinit &>/dev/null &
	echo 'Local browser restarted.'
fi

title -l = "$bar Extended fonts uninstalled successfully."
title -nt "$info Refresh browser for original fonts."

# clear opcache and restart local browser #######################################
systemctl reload php-fpm

if pgrep midori > /dev/null; then
	killall midori
	sleep 1
	xinit &> /dev/null &
fi

rm $0
