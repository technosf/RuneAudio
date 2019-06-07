#/bin/bash

alias=pers

. /srv/http/addonstitle.sh
. /srv/http/addonsedit.sh

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

echo -e "$bar Move Redis ..."
if ! grep -q "$pathsettings/redis" /etc/redis.conf; then
    mkdir -p $pathsettings/redis
    redis-cli config set dir $pathsettings/redis &> /dev/null
    redis-cli config rewrite &> /dev/null
    if [[ -e $pathsettings/redis/rune.rdb ]]; then
        systemctl restart redis
    else
        redis-cli bgsave &> /dev/null
    fi
fi

moveDirLink() { # $1-pathold $2-chown
	echo -e "$bar Move $1"
	dirold=$( basename $1 )
	pathnew=$pathsettings/$dirold
	[[ ! -e "$pathnew" ]] && mv $1 "$pathsettings"
	rm -rf $1
	ln -s "$pathnew" $( dirname $1 )
	chown -R $2 "$pathnew" $1
}

moveDirLink /etc/netctl root:root

moveDirLink /var/lib/mpd mpd:audio
[[ ! -e "$pathsettings/mpd.conf" ]] && cp /etc/mpd.conf "$pathnew" # maintain changes
ln -sf "$pathnew/mpd.conf" /etc
chown -h mpd:audio /etc/mpd.conf
redis-cli set mpdconfhash $( md5sum /etc/mpd.conf | cut -d' ' -f1 ) &> /dev/null

installfinish $@

title -nt "$info Database and settings path: $( tcolor "$pathsettings" )"
