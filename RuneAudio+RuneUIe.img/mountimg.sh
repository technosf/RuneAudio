#!/bin/bash

# usage: mountimg FILE.img [1]
# 1 - /boot partition

if (( $# == 1 ])); then  # root
  loop=2
  mntpoint=/media/root
else                     # boot
  loop=1
  mntpoint=/media/boot
fi

kpartx -av $1
mkdir -p $mntpoint
mount /dev/mapper/loop0p$loop $mntpoint
echo "Partition available at $mntpoint"
