#/bin/bash

alias=pers

. /srv/http/addonstitle.sh
. /srv/http/addonsedit.sh

#title -l '=' "$bar Restore database and settings from persistent storage ..."
uninstallstart $@

if [[ ! -L /etc/netctl ]]; then
	echo -e "$info No persistent database and settings found."
	exit
fi

pathsettings=$( dirname $( readlink -f /etc/netctl ) )

removeDirLink() { # $1-pathlink $2-chown
	rm -rf $1
	cp -rf "$pathsettings/$( basename $1 )" $( dirname $1 )
	[[ -n $2 ]] && chown -R $2 $1
}
removeDirLink /etc/netctl

removeDirLink /var/lib/mpd mpd:audio
mv -f /var/lib/mpd/mpd.conf /etc # restore changes

redis-cli save &> /dev/null
systemctl stop redis
removeDirLink /var/lib/redis redis:redis
file=/usr/lib/systemd/system/redis.service
restorefile $file
systemctl daemon-reload
systemctl restart redis #rune_SY_wrk rune_PL_wrk

#title -nt "$bar Database and settings restore successfully."
uninstallfinish $@
