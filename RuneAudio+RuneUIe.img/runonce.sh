#!/bin/bash

rm $0

# expand partition
echo -e 'd\n\nn\n\n\n\n\nw' | fdisk /dev/mmcblk0 &>/dev/null
partprobe /dev/mmcblk0
resize2fs /dev/mmcblk0p2

# wait for usb/nas drive mounted
while $( sleep 1 ); do
	grep -q '/mnt/MPD/USB' /proc/mounts && break
	
	(( i++ ))
	if (( i > 5 )); then
		curl -s -X POST 'http://localhost/pub?id=notify' -d '{ "title": "USB Drive", "text": "No USB drive found.", "icon": "usbdrive" }'
		break
	fi
done

# makeDirLink
. /srv/http/addonstitle.sh

makeDirLink bookmarks
makeDirLink coverarts
makeDirLink lyrics
makeDirLink playlists
makeDirLink tmp
makeDirLink webradiopl
makeDirLink webradios

makeDirLink mpd
chown -R mpd:audio /srv/http/assets/img/mpd

makeDirLink redis
dir=/srv/http/assets/img/redis
chown -R redis:rdis $dir
[[ -z $( ls $dir ) ]] && cp /var/lib/redis/* $dir

systemctl disable --now runonce
rm /etc/systemd/system/runonce.service

systemctl enable enhancestartup
/srv/http/enhancestartup.sh

# update mpd database
if grep -q '/mnt/MPD/' /proc/mounts; then
	mpc rescan
	mpc idle update
	albumartist=$( mpc list albumartist | awk NF | wc -l )
	composer=$( mpc list composer | awk NF | wc -l )
	genre=$( mpc list genre | awk NF | wc -l )
	redis-cli set mpddb "$albumartist $composer $genre"
	curl -s -X POST 'http://localhost/pub?id=reload' -d 1
fi
