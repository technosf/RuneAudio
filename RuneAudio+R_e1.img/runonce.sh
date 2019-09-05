#!/bin/bash

rm $0

# makeDirLink
. /srv/http/addonstitle.sh

dirs='bookmarks
coverarts
lyrics
mpd
playlists
redis
tmp
webradiopl
webradios'

for dir in $dirs; do
	extraDir $dir
done

dir=/srv/http/assets/img/redis
if [[ -z $( ls $dir ) ]]; then
	cp /var/lib/redis/* $dir
	chown -R redis:redis $dir "$( readlink -f "$dir" )"
fi

sed -i -e '\|^#dir /srv/http/assets/img/redis/| s|^#||' -e '\|^dir /var/lib/redis/| s|^|#|' /etc/redis.conf

systemctl start redis mpd

# set .mpdignore for extra directories
file="$( ls -d /mnt/MPD/USB/*/ ).mpdignore"
if [[ ! -e "$file" ]]; then
echo "$dirs" > "$file"
fi

# reset I2S setting
redis-cli set audiooutput 'bcm2835 ALSA_1'
#temp
redis-cli del AccessPoint activePlayer ao ao0  audiooutput0 dirble i2sname i2ssysname librandom mixer_type

# update mpd count
setCount() {
	albumartist=$( mpc list albumartist | awk NF | wc -l )
	composer=$( mpc list composer | awk NF | wc -l )
	genre=$( mpc list genre | awk NF | wc -l )
	redis-cli set mpddb "$albumartist $composer $genre"
}
if [[ -e /srv/http/assets/img/mpd/mpd.db ]]; then
	setCount
else
	mpc rescan
	mpc idle update
	setCount
	curl -s -X POST 'http://localhost/pub?id=reload' -d 1
fi

# expand partition
if [[ $( sfdisk -F /dev/mmcblk0 | head -n1 | awk '{print $6}' ) > 0 ]]; then
	echo -e 'd\n\nn\n\n\n\n\nw' | fdisk /dev/mmcblk0 &>/dev/null
	partprobe /dev/mmcblk0
	resize2fs /dev/mmcblk0p2
fi
