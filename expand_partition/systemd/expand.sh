#!/bin/bash

rm $0

unpartb=$( sfdisk -F | grep /dev/mmcblk0 | awk '{print $6}' )

echo -e 'd\n\nn\n\n\n\n\nw' | fdisk /dev/mmcblk0 &>/dev/null
partprobe /dev/mmcblk0
resize2fs /dev/mmcblk0p2

systemctl disable expand
rm /etc/systemd/system/expand.service
systemctl daemon-reload
