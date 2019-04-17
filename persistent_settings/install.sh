#/bin/bash

alias=pers

. /srv/http/addonstitle.sh
. /srv/http/addonsedit.sh

#title -l '=' "$bar Set persistent database and settings ..."
installstart $@

getuninstall

makeDirLink settings
imgsettings=/srv/http/assets/img/settings
if [[ ! -L $imgsettings ]]; then
	nas=$( df | grep -m1 '/mnt/MPD/NAS' | awk '{print $NF}' )
	if [[ $nas ]]; then
		echo -e "$info $( tcolor $nas ) is not writable."
		echo "Set write permission or plug in a USB drive."
	else
		echo -e "$info No USB or NAS found."
		echo "Plug in a USB drive."
	fi
	rm -rf $imgsettings
	exit
fi

pathsettings=$( readlink -f $imgsettings )
rm -rf $imgsettings

moveDirLink() { # $1-pathold $2-chown $3-no ln
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

file=/usr/lib/systemd/system/redis.service
commentS 'ExecStartPre'
commentS 'RestartSec'
commentS 'StartLimit'
systemctl daemon-reload
systemctl restart redis #rune_SY_wrk rune_PL_wrk

#title -nt "$info database and settings moved to: $( tcolor "$pathsettings" )"
installfinish $@
