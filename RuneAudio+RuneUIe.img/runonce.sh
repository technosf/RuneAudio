#!/bin/bash

rm $0

# expand partition
echo -e 'd\n\nn\n\n\n\n\nw' | fdisk /dev/mmcblk0 &>/dev/null
partprobe /dev/mmcblk0
resize2fs /dev/mmcblk0p2

# makeDirLink
. /srv/http/addonstitle.sh
makeDirLink bookmarks
makeDirLink coverarts
makeDirLink playlists
makeDirLink tmp
makeDirLink webradiopl
makeDirLink webradios

# update mpd database
{ mpc update;\
	albumartist=$( mpc list albumartist | awk NF | wc -l );\
	composer=$( mpc list composer | awk NF | wc -l );\
	genre=$( mpc list genre | awk NF | wc -l );\
	redis-cli set mpddb "$albumartist $composer $genre"; } &

systemctl disable runonce
rm /etc/systemd/system/runonce.service
systemctl daemon-reload
