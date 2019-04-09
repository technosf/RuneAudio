#/bin/bash

alias=pers

. /srv/http/addonstitle.sh

title -l '=' "$bar Set persistent database and settings ..."

makeDirLink settings
imgsettings=/srv/http/assets/img/settings
if [[ ! -L $imgsettings ]]; then
	echo -e "$info No persistent storage found/writable in USB/NAS"
	rm -rf $imgsettings
	exit
fi

pathsettings=$( readlink -f $imgsettings )
rm -rf $imgsettings

moveDirLink() { # $1-pathold $2-chown
	dirold=$( basename $1 )
	pathnew=$pathsettings/$dirold
	[[ ! -e "$pathnew" ]] && mv $1 "$pathsettings"
	rm -rf $1
	ln -s "$pathnew" $( dirname $1 )
	[[ -n $2 ]] && chown -R $2 "$pathnew" $1
}
moveDirLink /etc/netctl

moveDirLink /var/lib/mpd mpd:audio
[[ ! -e "$pathsettings/mpd.conf" ]] && cp /etc/mpd.conf "$pathnew" # maintain changes
ln -sf "$pathnew/mpd.conf" /etc

redis-cli save &> /dev/null
systemctl stop redis
moveDirLink /var/lib/redis redis:redis
systemctl start redis

title -nt "$info database and settings moved to: $( tcolor "$pathsettings" )"
