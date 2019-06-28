#!/bin/bash

rm $0

echo -e 'd\n\nn\n\n\n\n\nw' | fdisk /dev/mmcblk0 &>/dev/null
partprobe /dev/mmcblk0
resize2fs /dev/mmcblk0p2

systemctl disable expand
rm /lib/systemd/system/expand.service
systemctl daemon-reload
