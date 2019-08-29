#!/bin/bash

rm $0

# expand partition
if [[ $( sfdisk -F /dev/mmcblk0 | head -n1 | awk '{print $6}' ) > 0 ]]; then
	echo -e 'd\n\nn\n\n\n\n\nw' | fdisk /dev/mmcblk0 &>/dev/null
	partprobe /dev/mmcblk0
	resize2fs /dev/mmcblk0p2
fi

# wait for usb/nas drive mounted
while $( sleep 1 ); do
	grep -q '/mnt/MPD/USB' /proc/mounts && break
	
	(( i++ ))
	if (( i > 10 )); then
		curl -s -X POST 'http://localhost/pub?id=notify' -d '{ "title": "USB Drive", "text": "No USB drive found.", "icon": "usbdrive" }'
		break
	fi
done

# makeDirLink
. /srv/http/addonstitle.sh

makeDirLink bookmarks
makeDirLink coverarts
makeDirLink lyrics
makeDirLink mpd
makeDirLink playlists
makeDirLink redis
makeDirLink tmp
makeDirLink webradiopl
makeDirLink webradios

dir=/srv/http/assets/img/mpd
chown -R mpd:audio $dir "$( readlink -f "$dir" )"

dir=/srv/http/assets/img/redis
[[ -z $( ls $dir ) ]] && cp /var/lib/redis/* $dir
chown -R redis:redis $dir "$( readlink -f "$dir" )"
sed -i -e '\|^#dir /srv/http/assets/img/redis/| s|^#||' -e '\|^dir /var/lib/redis/| s|^|#|' /etc/redis.conf

systemctl restart mpd redis
systemctl disable runonce

# reset I2S setting
redis-cli set audiooutput 'bcm2835 ALSA_1'
redis-cli del i2sname i2ssysname

# update mpd database
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

rm /etc/systemd/system/runonce.service
systemctl daemon-reload
