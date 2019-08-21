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
makeDirLink mpd
makeDirLink playlists
makeDirLink tmp
makeDirLink webradiopl
makeDirLink webradios

chown -RhL mpd:audio /srv/http/assets/img/mpd

systemctl disable runonce

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

rm /etc/systemd/system/runonce.service
systemctl daemon-reload
