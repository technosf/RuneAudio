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
mpd update
/srv/http/enhancecount.sh

systemctl disable expand
rm /lib/systemd/system/expand.service
systemctl daemon-reload
