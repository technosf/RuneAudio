#/bin/bash

alias=pers

. /srv/http/addonstitle.sh

title -l '=' "$bar Restore database and settings from persistent storage ..."

pathsettings=$( dirname $( readlink -f /etc/netctl ) )

removeDirLink() { # $1-pathlink $2-chown
	echo -e "$bar $1"
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
systemctl start redis

title -nt "$bar Database and settings restore successfully."
