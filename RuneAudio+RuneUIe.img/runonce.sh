#!/bin/bash

rm $0
systemctl disable runonce
rm /etc/systemd/system/runonce.service

# expand partition
echo -e 'd\n\nn\n\n\n\n\nw' | fdisk /dev/mmcblk0 &>/dev/null
partprobe /dev/mmcblk0
resize2fs /dev/mmcblk0p2

# wait for usb/nas drive mounted
i=0
while ! grep -q '/mnt/MPD/' /proc/mounts && (( $i < 30 )); do
	sleep 1
	(( i++ ))
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

# update mpd database
if grep -q '/mnt/MPD/' /proc/mounts; then
	mpc rescan
	mpc idle update
	albumartist=$( mpc list albumartist | awk NF | wc -l )
	composer=$( mpc list composer | awk NF | wc -l )
	genre=$( mpc list genre | awk NF | wc -l )
	redis-cli set mpddb "$albumartist $composer $genre"
	curl -s -v -X POST 'http://localhost/pub?id=reload' -d 1
fi

startx &> /dev/null &
